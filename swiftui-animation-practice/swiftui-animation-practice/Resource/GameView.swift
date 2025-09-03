//
//  GameView.swift
//  swiftui-animation-practice
//
//  Created by 김태형 on 9/3/25.
//

import SwiftUI

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

#Preview(traits: .landscapeLeft) {
    GameView()
        .ignoresSafeArea()
}
