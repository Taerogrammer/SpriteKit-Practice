//
//  LogView.swift
//  swiftui-animation-practice
//
//  Created by 김태형 on 9/2/25.
//

import SwiftUI

struct LogContainerView: View {
    let logCount: Int
    let size: CGFloat
    let spacing: CGFloat
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(1...logCount, id: \.self) { index in
                LogView(logNumber: index, size: size)
            }
        }
    }
}

struct LogView: View {
    let logNumber: Int
    let size: CGFloat // 이제 height 기준
    
    var body: some View {
        ZStack {
            // 통나무 - 실제 비율 적용
            Image("log")
                .frame(
                    width: size * GameConstants.logImageAspectRatio,
                    height: size
                )

            Text("\(logNumber)")
                .font(.system(size: size * 0.3))
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}

#Preview(traits: .landscapeLeft) {
    LogView(logNumber: 3, size: 160)
}
