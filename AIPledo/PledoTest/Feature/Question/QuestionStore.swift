//
//  QuestionStore.swift
//  PledoTest
//
//  Created by 이중엽 on 9/3/25.
//

import SwiftUI

import ComposableArchitecture

@Reducer
struct QuestionStore {

    let repository = QuestionRepository()

    private enum Constant {
        static let bridgeSpacing: CGFloat = 20
        static let leftPaddingScale: CGFloat = 0.2
        static let characterAnimationDuration = 0.8
        static let characterAnimationDelay = 0.2
    }

    @ObservableState
    struct State: Equatable {
        var isOn = true
        var quizID: Int = 1
        var questions: [QuestionEntity] = []
        var question: QuestionEntity?
        var isTouchable: Bool = true
        var isShowingAnswer: Bool = false
        var isShowingWrong: Bool = false

        // MARK: - Animation State
        var characterOffsetX: CGFloat = 0
        var characterOffsetY: CGFloat = 0
        var currentLogIndex: Int = 0
        var isAnimating: Bool = false
        
        // 포물선 애니메이션을 위한 새로운 상태들
        var animationProgress: CGFloat = 0 // 0.0 ~ 1.0
        var animationStartX: CGFloat = 0
        var animationEndX: CGFloat = 0
        var isJumping: Bool = false
        
        // 포물선 계산을 위한 computed property
        var parabolicOffsetY: CGFloat {
            guard isJumping else { return 0 }
            
            // 마지막 점프일 때는 더 높게
            let isLastJump = currentLogIndex > tokenQuestionText.count
            let baseHeight: CGFloat = isLastJump ? 120 : 100 // 마지막은 더 높게
            let h: CGFloat = baseHeight * scaleFactor
            let x = animationProgress
            return 2 * h * x * (x - 1)
        }
        
        var parabolicOffsetX: CGFloat {
            guard isJumping else { return characterOffsetX }
            
            // X축은 선형 보간
            return animationStartX + (animationEndX - animationStartX) * animationProgress
        }

        // MARK: - Computed Properties
        var sentenceQuestionText: [QuestionTextType] {
            question?.sentenceQuestionText ?? []
        }
        var tokenQuestionText: [QuestionTextType] {
            question?.tokenQuestionText ?? []
        }

        var scaleFactor: CGFloat {
            let original: CGFloat = 720 / UIScreen.main.scale
            let screen = UIScreen.main.bounds.height
            return screen / original
        }

        var initialCharacterOffsetX: CGFloat {
            let characterWidth = UIImage.berryIdle.size.width * scaleFactor
            return -characterWidth * 0.5 + UIScreen.main.bounds.width * Constant.leftPaddingScale * 0.33
        }

        var characterCurrentCenterX: CGFloat {
            let characterWidth = UIImage.berryIdle.size.width * scaleFactor
            return initialCharacterOffsetX + characterOffsetX + characterWidth / 2
        }

        var totalWidth: CGFloat {
            let logWidth = UIImage.log.size.width * scaleFactor
            let numberOfLogs = sentenceQuestionText.count
            let numberOfHorizontalItems = sentenceQuestionText.count + 2
            let sidePadding = UIScreen.main.bounds.width * Constant.leftPaddingScale
            let totalLogsWidth = logWidth * CGFloat(numberOfLogs)
            let totalSpacingWidth = Constant.bridgeSpacing * CGFloat(numberOfHorizontalItems - 1)
            let bgEndWidth = UIImage.bgEnd.size.width * scaleFactor
            return sidePadding + totalLogsWidth + totalSpacingWidth + bgEndWidth
        }

        var logPositions: [CGFloat] {
            var positions: [CGFloat] = []
            let leftPadding = UIScreen.main.bounds.width * Constant.leftPaddingScale
            let logWidth = UIImage.log.size.width * scaleFactor
            let blankWidth = UIImage.blankOn.size.width * scaleFactor
            let spacing = Constant.bridgeSpacing

            var currentXOffset = leftPadding

            for token in tokenQuestionText {
                switch token {
                case .normal:
                    positions.append(currentXOffset + logWidth / 2)
                    currentXOffset += logWidth + spacing
                case .question:
                    positions.append(currentXOffset + blankWidth / 2)
                    currentXOffset += blankWidth + spacing
                }
            }
            return positions
        }
    }

    enum Action {
        case onAppear
        case timerTick
        case levelButtonClicked(Int)
        case passButtonClicked
        case questionsResponse([QuestionEntity])
        case fetchFailed(Error)
        case animationStarted
        case animationEnded
        case showCorrectAnswer
        case hideCorrectAnswer
        case showWrongAnswer
        case hideWrongAnswer

        // MARK: - Animation Actions
        case startCharacterAnimation
        case animateToNextLog

        case startParabolicJump(from: CGFloat, to: CGFloat)
        case updateParabolicProgress(CGFloat)
        case finishParabolicJump
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    do {
                        let fetchedQuestions = try await repository.fetchQuestions()
                        await send(.questionsResponse(fetchedQuestions))
                    } catch {
                        await send(.fetchFailed(error))
                    }
                }

            case .questionsResponse(let questions):
                state.questions = questions
                state.question = questions[state.quizID - 1]
                return .none

            case .fetchFailed(let error):
                print("❌ fetch error: \(error.localizedDescription)")
                return .none

            case .timerTick:
                state.isOn.toggle()
                return .none

            case .levelButtonClicked(let level):
                state.quizID = level
                state.question = state.questions[level - 1]
                return .none

            case .passButtonClicked:
                // 다음 문제로 넘어갈 때 애니메이션 상태 초기화
                state.characterOffsetX = 0
                state.characterOffsetY = 0
                state.currentLogIndex = 0
                state.isAnimating = false
                state.isJumping = false
                state.animationProgress = 0

                let nextQuizID = (state.quizID % state.questions.count) + 1
                state.quizID = nextQuizID
                state.question = state.questions[nextQuizID - 1]
                return .none

            case .animationStarted:
                state.isTouchable = false
                return .none

            case .animationEnded:
                state.isTouchable = true
                return .none

            case .showCorrectAnswer:
                state.isShowingAnswer = true
                state.isTouchable = false
                return .run { send in
                    try await Task.sleep(for: .seconds(2))
                    await send(.hideCorrectAnswer)
                }

            case .hideCorrectAnswer:
                state.isShowingAnswer = false
                state.isTouchable = true
                return .send(.startCharacterAnimation)

            case .showWrongAnswer:
                state.isShowingWrong = true
                state.isTouchable = false
                return .run { send in
                    try await Task.sleep(for: .seconds(2))
                    await send(.hideWrongAnswer)
                }

            case .hideWrongAnswer:
                state.isShowingWrong = false
                state.isTouchable = true
                return .none

            // MARK: - Character Animation Logic
            case .startCharacterAnimation:
                guard !state.tokenQuestionText.isEmpty else { return .none }
                state.isAnimating = true
                state.currentLogIndex = 0
                state.characterOffsetY = 0
                state.isJumping = false
                state.animationProgress = 0
                return .send(.animateToNextLog)

            case .animateToNextLog:
                let logPositions = state.logPositions

                guard state.currentLogIndex < logPositions.count else {
                    state.currentLogIndex += 1
                    let screenWidth = UIScreen.main.bounds.width
                    let characterWidth = UIImage.berryIdle.size.width * 2 * state.scaleFactor
                    let currentCharacterX = state.characterCurrentCenterX
                    let offScreenTargetX = screenWidth + characterWidth * 0.7 // 화면 밖 목표 지점
                    
                    return .send(.startParabolicJump(from: currentCharacterX, to: offScreenTargetX))
                }

                let targetLogCenterX = logPositions[state.currentLogIndex]
                let currentCharacterX = state.characterCurrentCenterX
                
                state.currentLogIndex += 1

                return .send(.startParabolicJump(from: currentCharacterX, to: targetLogCenterX))

            case .startParabolicJump(let fromX, let toX):
                state.isJumping = true
                state.animationProgress = 0
                state.animationStartX = fromX - state.characterCurrentCenterX + state.characterOffsetX
                state.animationEndX = toX - state.characterCurrentCenterX + state.characterOffsetX
                
                return .run { send in
                    let duration: Double = Constant.characterAnimationDuration
                    let steps = Int(duration * 60) // 60fps
                    
                    for step in 1...steps {
                        let progress = CGFloat(step) / CGFloat(steps)
                        try await Task.sleep(for: .seconds(duration / Double(steps)))
                        await send(.updateParabolicProgress(progress))
                    }
                    
                    await send(.finishParabolicJump)
                }

            case .updateParabolicProgress(let progress):
                state.animationProgress = progress
                return .none

            case .finishParabolicJump:
                print("점프 완료 - currentLogIndex: \(state.currentLogIndex), tokenCount: \(state.tokenQuestionText.count)")
                state.isJumping = false
                state.characterOffsetX = state.animationEndX
                state.characterOffsetY = 0
                state.animationProgress = 0
                
                // 모든 통나무를 방문했는지 확인
                if state.currentLogIndex > state.tokenQuestionText.count {
                    // 마지막 점프가 끝났으면 다음 문제로
                    return .run { send in
                        try await Task.sleep(for: .seconds(0.5)) // 잠깐 대기
                        await send(.passButtonClicked)
                    }
                } else {
                    // 아직 더 방문할 통나무가 있으면 계속
                    return .run { send in
                        try await Task.sleep(for: .seconds(Constant.characterAnimationDelay))
                        await send(.animateToNextLog)
                    }
                }
            }
        }
    }
}
