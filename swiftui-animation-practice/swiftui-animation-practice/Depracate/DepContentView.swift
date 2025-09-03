//
//  ContentView.swift
//  swiftui-animation-practice
//
//  Created by 김태형 on 9/2/25.
//

import SwiftUI

struct DepContentView: View {
    var body: some View {
        DepGameView()
            .ignoresSafeArea()
    }
}

#Preview(traits: .landscapeLeft) {
    DepContentView()
}
