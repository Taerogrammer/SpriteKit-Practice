//
//  ContentView.swift
//  swiftui-animation-practice
//
//  Created by 김태형 on 9/2/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GameView()
            .ignoresSafeArea()
    }
}

#Preview(traits: .landscapeLeft) {
    ContentView()
}
