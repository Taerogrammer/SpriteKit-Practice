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
            
            // 캐릭터 크기 계산
            let characterHeight = geometry.size.height * CharacterConstants.characterSizeRatio
            let characterWidth = characterHeight * CharacterConstants.characterImageAspectRatio
            
            // 첫 번째 통나무의 높이와 너비
            let firstLogHeight = geometry.size.height * GameConstants.logSizeRatio
            let firstLogWidth = firstLogHeight * GameConstants.logImageAspectRatio
            
            // 캐릭터 X 위치 계산: 시작 패딩 + (첫 통나무 너비의 절반) - (캐릭터 너비의 절반)
            let characterXPos = (geometry.size.width * GameConstants.leadingPaddingRatio) + (firstLogWidth / 2) - (characterWidth / 2)
            
            // 캐릭터 Y 위치 계산: 화면 높이 - 캐릭터 높이 - (통나무 높이의 일부를 겹치도록 조정)
            // 화면 하단에 맞춘 후 통나무 위로 끌어올리는 방식
            let characterYPos = geometry.size.height
                - characterHeight
            - (firstLogHeight * 1.75) // 통나무 높이의 절반 정도를 겹치게
            
            ScrollView(.horizontal, showsIndicators: false) {
                ZStack(alignment: .leading) {
                    Image("bg")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: totalContentWidth, height: geometry.size.height, alignment: .leading)
                        .clipped()
                        .ignoresSafeArea()
                    
                    // MARK: 캐릭터 뷰에 프레임 및 오프셋 적용
                    CharacterView()
                        .frame(width: characterWidth, height: characterHeight)
                        .position(x: characterXPos, y: characterYPos)
                    
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

// MARK: - Character Constants
struct CharacterConstants {
    static let characterOriginalWidth: CGFloat = 536
    static let characterOriginalHeight: CGFloat = 343
    static let characterImageAspectRatio: CGFloat = characterOriginalWidth / characterOriginalHeight
    static let characterSizeRatio: CGFloat = 0.4
}


struct CharacterView: View {
    @State private var currentImageIndex = 0
    private let imageNames = ["k_cha_berry04_01", "k_cha_berry04_02"]
    private let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Image(imageNames[currentImageIndex])
            .resizable()
            .scaledToFit()
            .onReceive(timer) { _ in
                currentImageIndex = (currentImageIndex + 1) % imageNames.count
            }
    }
}

#Preview(traits: .landscapeLeft) {
    GameView()
        .ignoresSafeArea()
}
