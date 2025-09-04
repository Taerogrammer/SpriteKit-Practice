//
//  WrongStore.swift
//  PledoTest
//
//  Created by 김태형 on 9/4/25.
//

import Foundation

import ComposableArchitecture

@Reducer
struct WrongStore {
    @ObservableState
    struct State: Equatable {
        var isAnimated = false
        var resultWrongOffset: CGFloat = -30
        var characterUPDownOffset: CGFloat = -30
        var characterLeftRightOffset: CGFloat = 0
        var wrongMentOffset: CGFloat = 30
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
                    try await Task.sleep(nanoseconds: 100_000_000)
                    await send(.animateImages)
                }
            case .animateImages:
                state.isAnimated = true
                state.resultWrongOffset = 0
                state.characterUPDownOffset = 0
                state.characterLeftRightOffset = 10
                state.wrongMentOffset = 0
                
                return .none
            }
        }
    }
}
