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
    static let leadingPaddingRatio: CGFloat = 0.18
    static let logSizeRatio: CGFloat = 0.18
    static let logSpacing: CGFloat = 180 // 모든 간격을 동일하게
    static let endingImageAspectRatio: CGFloat = 343.0 / 721.0
    
    static func calculateMaxOffset(for screenSize: CGSize) -> CGFloat {
        let leadingPadding = screenSize.width * leadingPaddingRatio
        let logSize = screenSize.height * logSizeRatio
        let endingImageWidth = screenSize.height * endingImageAspectRatio
        
        // 실제 콘텐츠 너비 계산
        let logContainerWidth = (CGFloat(logCount) * logSize) + (CGFloat(logCount - 1) * logSpacing)
        
        let totalContentWidth = leadingPadding + logContainerWidth + logSpacing + endingImageWidth
        
        return max(0, totalContentWidth - screenSize.width)
    }
    
}

struct ContentView: View {
    var body: some View {
        GeometryReader { geometry in
            GameView()
                .limitedScroll(
                    minOffset: 0,
                    maxOffset: GameConstants.calculateMaxOffset(for: geometry.size)
                )
                .ignoresSafeArea()
        }
    }
}

#Preview(traits: .landscapeLeft) {
    ContentView()
}

struct GameView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width + GameConstants.calculateMaxOffset(for: geometry.size), height: geometry.size.height, alignment: .leading)
                    .clipped()
                    .ignoresSafeArea()
                
                HStack(spacing: 60) {
                    LogContainerView(
                        logCount: GameConstants.logCount,
                        size: geometry.size.height * GameConstants.logSizeRatio,
                        spacing: GameConstants.logSpacing // 통나무들끼리는 180 간격
                    )

                    Image("ending")
                        .resizable()
                        .scaledToFit()
                        .frame(height: geometry.size.height)
                        .background(
                            GeometryReader { endingGeometry in
                                Color.clear
                                    .onAppear {
                                        let globalFrame = endingGeometry.frame(in: .global)
                                        let localFrame = endingGeometry.frame(in: .local)
                                        print("Ending global X: \(globalFrame.origin.x)")
                                        print("Ending local X: \(localFrame.origin.x)")
                                    }
                            }
                        )
                }
                .padding(.leading, geometry.size.width * GameConstants.leadingPaddingRatio)
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
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // 통나무
            Image("log")
                .frame(width: size, height: size)

            // 통나무 위 텍스트
            Text("\(logNumber)")
                .font(.system(size: size * 0.3))
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Custom ViewModifier
struct ScrollableModifier: ViewModifier {
    @State private var scrollOffset: CGFloat = 0
    
    let minOffset: CGFloat
    let maxOffset: CGFloat
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .frame(width: geometry.size.width + maxOffset, height: geometry.size.height, alignment: .leading)
                .clipped()
                .offset(x: -scrollOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let newOffset = scrollOffset - value.translation.width
                            scrollOffset = min(max(minOffset, newOffset), maxOffset)
                        }
                )
        }
    }
}

// MARK: - View Extension
extension View {
    func limitedScroll(minOffset: CGFloat = 0, maxOffset: CGFloat) -> some View {
        self.modifier(ScrollableModifier(minOffset: minOffset, maxOffset: maxOffset))
    }
}
