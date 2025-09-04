//
//  AnswerStore.swift
//  PledoTest
//
//  Created by 김태형 on 9/4/25.
//

import Foundation

import ComposableArchitecture

@Reducer
struct AnswerStore {
    @ObservableState
    struct State: Equatable {
        var isAnimated = false
        var resultAnswerOffset: CGFloat = 0
        var berry03Offset: CGFloat = 0
        var answerMent09Offset: CGFloat = 0
    }
    
    enum Action {
        case onAppear
        case animateImages
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    try await Task.sleep(nanoseconds: 200_000_000)
                    await send(.animateImages)
                }
            case .animateImages:
                state.isAnimated = true
                state.resultAnswerOffset = -30
                state.berry03Offset = -30
                state.answerMent09Offset = 30
                
                return .none
            }
        }
    }
}
