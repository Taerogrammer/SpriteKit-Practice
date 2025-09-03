//
//  ContentView.swift
//  swiftui-animation-practice
//
//  Created by 김태형 on 9/2/25.
//

import SwiftUI

// MARK: - Game Constants
struct GameConstants {
    static let logCount: Int = 4
    static let leadingPaddingRatio: CGFloat = 0.24
    static let logSizeRatio: CGFloat = 0.18
    static let logSpacing: CGFloat = 120
    static let containerSpacing: CGFloat = 40
    static let logImageAspectRatio: CGFloat = 293.0 / 215.0
    static let endingImageAspectRatio: CGFloat = 343.0 / 721.0
    
    static func calculateTotalContentWidth(for screenSize: CGSize) -> CGFloat {
        let leadingPadding = screenSize.width * leadingPaddingRatio
        let logHeight = screenSize.height * logSizeRatio
        let logWidth = logHeight * logImageAspectRatio
        let endingImageWidth = screenSize.height * endingImageAspectRatio
        
        let logContainerWidth = (CGFloat(logCount) * logWidth) + (CGFloat(logCount - 1) * logSpacing)
        
        return leadingPadding + logContainerWidth + containerSpacing + endingImageWidth
    }
}

struct ContentView: View {
    var body: some View {
        GameView()
            .ignoresSafeArea()
    }
}

#Preview(traits: .landscapeLeft) {
    ContentView()
}

struct GameView: View {
    var body: some View {
        GeometryReader { geometry in
            let totalContentWidth = GameConstants.calculateTotalContentWidth(for: geometry.size)
            ScrollView(.horizontal, showsIndicators: false) {
                ZStack(alignment: .leading) {
                    Image("bg")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: totalContentWidth, height: geometry.size.height, alignment: .leading)
                        .clipped()
                        .ignoresSafeArea()
                    
                    HStack(spacing: GameConstants.containerSpacing) {
                        LogContainerView(
                            logCount: GameConstants.logCount,
                            size: geometry.size.height * GameConstants.logSizeRatio,
                            spacing: GameConstants.logSpacing
                        )
                        
                        Image("ending")
                            .resizable()
                            .scaledToFit()
                            .frame(height: geometry.size.height)
                    }
                    .padding(.leading, geometry.size.width * GameConstants.leadingPaddingRatio)
                }
                .frame(width: totalContentWidth)
            }
            .onAppear {
                UIScrollView.appearance().bounces = false
            }
        }
    }
}

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
