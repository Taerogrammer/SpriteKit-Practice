//
//  GameView.swift
//  swiftui-animation-practice
//
//  Created by 김태형 on 9/3/25.
//

import SwiftUI

struct GameView: View {
    // MARK: - 애니메이션 상태 변수
    @State private var animateScroll = false

    
    var body: some View {
        GeometryReader { geometry in
            let totalContentWidth = GameConstants.calculateTotalContentWidth(for: geometry.size)

            // 캐릭터 크기 계산
            let characterHeight = geometry.size.height * CharacterConstants.characterSizeRatio
            let characterWidth = characterHeight * CharacterConstants.characterImageAspectRatio
            
            // 첫 번째 통나무의 높이와 너비
            let firstLogHeight = geometry.size.height * GameConstants.logSizeRatio
            let firstLogWidth = firstLogHeight * GameConstants.logImageAspectRatio
            
            // 캐릭터 X 위치 계산
            let characterXPos = (geometry.size.width * GameConstants.leadingPaddingRatio) + (firstLogWidth / 2) - (characterWidth / 2)
            
            // 캐릭터 Y 위치 계산
            let characterYPos = geometry.size.height - characterHeight - (firstLogHeight * 1.75)

            // MARK: - ScrollViewReader를 사용하여 스크롤 제어
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    ZStack(alignment: .leading) {
                        Image("bg")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: totalContentWidth, height: geometry.size.height, alignment: .leading)
                            .clipped()
                            .ignoresSafeArea()
                            .id("background") // 애니메이션을 위한 ID 설정
                        
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
                        
                        VStack(alignment: .leading) {
                            Spacer()
                            HStack(spacing: 16) {
                                Button {
                                    print("zz")
                                } label: {
                                    Image("btn_right")
                                }
                                
                                Button {
                                    print("오답")
                                } label: {
                                    Image("btn_wrong")
                                }
                            }
                        }
                        .padding()
                    }
                    .frame(width: totalContentWidth)
                }
                .onAppear {
                    UIScrollView.appearance().bounces = false
                    
                    // MARK: - 애니메이션 로직
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeOut(duration: 1.5)) {
                            // 전체 콘텐츠 너비만큼 스크롤
                            proxy.scrollTo("background", anchor: .trailing)
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                            withAnimation(.easeInOut(duration: 1.5)) {
                                // 2초 후 다시 초기 위치로 돌아옴
                                proxy.scrollTo("background", anchor: .leading)
                            }
                        }
                    }
                }
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
