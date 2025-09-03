//
//  GameView.swift
//  swiftui-animation-practice
//
//  Created by 김태형 on 9/3/25.
//

import SwiftUI

struct DepGameView: View {
    // MARK: - 애니메이션 상태 변수
    @State private var isAnimating = false

    var body: some View {
        GeometryReader { geometry in
            let totalContentWidth = DepGameConstants.calculateTotalContentWidth(for: geometry.size)
            
            // 캐릭터 크기 계산
            let characterHeight = geometry.size.height * CharacterConstants.characterSizeRatio
            let characterWidth = characterHeight * CharacterConstants.characterImageAspectRatio
            
            // 첫 번째 통나무의 높이와 너비
            let firstLogHeight = geometry.size.height * DepGameConstants.logSizeRatio
            let firstLogWidth = firstLogHeight * DepGameConstants.logImageAspectRatio
            
            // 캐릭터 X 위치 계산
            let characterXPos = (geometry.size.width * DepGameConstants.leadingPaddingRatio) + (firstLogWidth / 2) - (characterWidth / 2)
            
            // 캐릭터 Y 위치 계산
            let characterYPos = geometry.size.height - characterHeight - (firstLogHeight * 1.75)

            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    ZStack(alignment: .leading) {
                        Image("bg")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: totalContentWidth, height: geometry.size.height, alignment: .leading)
                            .clipped()
                            .ignoresSafeArea()
                            .id("background")

                        CharacterView()
                            .frame(width: characterWidth, height: characterHeight)
                            .position(x: characterXPos, y: characterYPos)
                    
                        HStack {
                            DepLogContainerView(
                                logCount: DepGameConstants.logCount,
                                size: geometry.size.height * DepGameConstants.logSizeRatio,
                                spacing: DepGameConstants.logSpacing
                            )
                        }
                        .padding(.leading, geometry.size.width * DepGameConstants.leadingPaddingRatio)
                      
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
                .allowsHitTesting(!isAnimating)
                .onAppear {
                    UIScrollView.appearance().bounces = false
                    
                    isAnimating = true // 애니메이션 시작
                    
                    Task {
                        // 0.5초 대기
                        try await Task.sleep(nanoseconds: 500_000_000)
                        
                        // 첫 번째 스크롤 애니메이션 (오른쪽으로)
                        withAnimation(.easeOut(duration: 1.5)) {
                            proxy.scrollTo("background", anchor: .trailing)
                        }
                        
                        // 첫 번째 애니메이션이 끝날 때까지 대기
                        try await Task.sleep(nanoseconds: 1_500_000_000)
                        
                        // 두 번째 스크롤 애니메이션 (왼쪽으로)
                        withAnimation(.easeInOut(duration: 1.5)) {
                            proxy.scrollTo("background", anchor: .leading)
                        }
                        
                        // 두 번째 애니메이션이 끝날 때까지 대기
                        try await Task.sleep(nanoseconds: 1_500_000_000)
                        
                        // 모든 애니메이션이 끝난 후 터치 허용
                        isAnimating = false
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
    DepGameView()
        .ignoresSafeArea()
}
