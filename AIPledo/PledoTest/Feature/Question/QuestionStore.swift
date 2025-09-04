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
        var currentLogIndex: Int = 0
        var isAnimating: Bool = false

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
        case characterAnimationFinished
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
                state.currentLogIndex = 0
                state.isAnimating = false

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
                return .send(.animateToNextLog, animation: .easeInOut(duration: Constant.characterAnimationDuration))

            case .animateToNextLog:
                let logPositions = state.logPositions

                guard state.currentLogIndex < logPositions.count else {
                    return .send(.characterAnimationFinished, animation: .easeIn(duration: 1.2))
                }

                let targetLogCenterX = logPositions[state.currentLogIndex]
                let moveDistance = targetLogCenterX - state.characterCurrentCenterX
                state.characterOffsetX += moveDistance
                state.currentLogIndex += 1

                return .run { send in
                    try await Task.sleep(for: .seconds(Constant.characterAnimationDuration + Constant.characterAnimationDelay))
                    await send(.animateToNextLog, animation: .easeInOut(duration: Constant.characterAnimationDuration))
                }

            case .characterAnimationFinished:
                let screenWidth = UIScreen.main.bounds.width
                let characterWidth = UIImage.berryIdle.size.width * 2 * state.scaleFactor
                let offScreenDistance = screenWidth - state.characterCurrentCenterX + characterWidth
                state.characterOffsetX += offScreenDistance

                return .run { send in
                    try await Task.sleep(for: .seconds(1.2))
                    await send(.passButtonClicked)
                }
            }
        }
    }
}
