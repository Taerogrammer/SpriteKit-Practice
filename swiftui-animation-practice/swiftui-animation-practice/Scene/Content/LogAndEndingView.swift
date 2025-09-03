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
