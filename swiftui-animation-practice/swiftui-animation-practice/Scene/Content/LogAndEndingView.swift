//
//  LogAndEndingView.swift
//  swiftui-animation-practice
//
//  Created by 김태형 on 9/3/25.
//

import SwiftUI

struct LogAndEndingView: View {
    var body: some View {
        HStack(spacing: 12) {
            LogContainerView()

            Image("ending")
                .resizable()
                .scaledToFill()
                .frame(height: UIScreen.main.bounds.height)
                .scaledToScreen()
        }
        .frame(height: UIScreen.main.bounds.height)
        .background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometry.size)
            }
        )
    }
}

#Preview(traits: .landscapeLeft) {
    ScrollView(.horizontal, showsIndicators: false) {
        LogAndEndingView()
    }
    .onAppear {
        UIScrollView.appearance().bounces = false
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
