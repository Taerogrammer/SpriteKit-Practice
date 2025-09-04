//
//  PledoTestApp.swift
//  PledoTest
//
//  Created by 이중엽 on 9/2/25.
//

import SwiftUI

import ComposableArchitecture

@main
struct PledoTestApp: App {
    
    var body: some Scene {
        
        WindowGroup {
            QuestionView(store: Store(initialState: QuestionStore.State()) {
                QuestionStore()
            })
            .onAppear { UIScrollView.appearance().bounces = false }
        }
    }
}
