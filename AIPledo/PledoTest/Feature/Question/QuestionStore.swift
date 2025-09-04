//
//  QuestionStore.swift
//  PledoTest
//
//  Created by 이중엽 on 9/3/25.
//

import Foundation

import ComposableArchitecture

@Reducer
struct QuestionStore {
    
    let repository = QuestionRepository()
    
    @ObservableState
    struct State {
        var isOn = true
        var quizID: Int = 1
        var questions: [QuestionEntity] = []
        var question: QuestionEntity?
        var sentenceQuestionText: [QuestionTextType] = []
        var tokenQuestionText: [QuestionTextType] = []
        var isTouchable: Bool = true
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
                state.sentenceQuestionText = questions[state.quizID - 1].sentenceQuestionText
                state.tokenQuestionText = questions[state.quizID - 1].tokenQuestionText
                
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
                state.sentenceQuestionText = state.questions[level - 1].sentenceQuestionText
                state.tokenQuestionText = state.questions[level - 1].tokenQuestionText
                
                return .none
                
            case .passButtonClicked:
                state.quizID += 1
                state.question = state.questions[state.quizID - 1]
                state.sentenceQuestionText = state.questions[state.quizID - 1].sentenceQuestionText
                state.tokenQuestionText = state.questions[state.quizID - 1].tokenQuestionText
                
                return .none
                
            case .animationStarted:
                state.isTouchable = false
                
                return .none
                
            case .animationEnded:
                state.isTouchable = true
                
                return .none
            }
        }
    }
}
