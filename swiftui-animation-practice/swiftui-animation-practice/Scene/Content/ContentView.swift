//
//  ContentView.swift
//  swiftui-animation-practice
//
//  Created by 김태형 on 9/3/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isAnimating = false
    
    // 더미 데이터를 ContentView가 가지고 있도록 변경 (상태 관리 용이)
    private let dummyData: [LogEntity] = [
        LogEntity(type: .subject, word: "I"),
        LogEntity(type: .question, word: "AM"),
        LogEntity(type: .question, word: "ARE"),
        LogEntity(type: .subject, word: "HAPPY")
    ]
    
    var body: some View {
        GeometryReader { geometry in
            // --- 크기 계산 ---
            let leadingPadding = geometry.size.width * 0.2
            let logViewHeight = geometry.size.height // LogView의 높이를 화면 높이와 동일하게 설정
            
            // LogContainerView의 너비를 동적으로 계산
            let logContainerWidth = logViewHeight * CGFloat(dummyData.count) + 12 * CGFloat(dummyData.count - 1)
            
            // Ending 이미지의 너비 계산
            let endingImageWidth = logViewHeight
            
            // LogAndEndingView의 전체 너비 계산
            let totalContentWidth = logContainerWidth + 12 + endingImageWidth
            
            // ScrollView 내부 콘텐츠의 최종 너비
            let scrollContentWidth = leadingPadding + totalContentWidth
            
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    ZStack(alignment: .leading) {
                        Image("bg")
                            .resizable()
                            .scaledToFill()
                            .frame(width: scrollContentWidth, alignment: .leading)
                            .id("background")
                        
                        // 계산된 크기 정보를 자식 뷰에 전달
                        LogAndEndingView(dummyData: dummyData, geometry: geometry)
                            .padding(.leading, leadingPadding)
                            .id("ending")
                    }
                    // ScrollView가 콘텐츠의 크기를 정확히 알 수 있도록 프레임 설정
                    .frame(width: scrollContentWidth, height: geometry.size.height)
                }
                .allowsHitTesting(!isAnimating)
                .onAppear {
                    // ... (애니메이션 로직은 동일) ...
                    UIScrollView.appearance().bounces = false
                    isAnimating = true
                    Task {
                        try await Task.sleep(nanoseconds: 500_000_000)
                        withAnimation(.easeOut(duration: 1.5)) {
                            proxy.scrollTo("ending", anchor: .trailing)
                        }
                        try await Task.sleep(nanoseconds: 1_500_000_000)
                        withAnimation(.easeInOut(duration: 1.5)) {
                            proxy.scrollTo("background", anchor: .leading)
                        }
                        try await Task.sleep(nanoseconds: 1_500_000_000)
                        isAnimating = false
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview(traits: .landscapeLeft) {
    ContentView()
}
