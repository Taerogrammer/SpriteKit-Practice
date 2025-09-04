//
//  LogAndEndingView.swift
//  swiftui-animation-practice
//
//  Created by 김태형 on 9/3/25.
//

import SwiftUI

struct LogAndEndingView: View {
    let dummyData: [LogEntity]
    let geometry: GeometryProxy // 상위 뷰의 Geometry 정보를 통째로 받음

    var body: some View {
        HStack(spacing: 12) {
            LogContainerView(dummyData: dummyData, size: geometry.size)

            Image("ending")
                .resizable()
                .scaledToFill()
                // 이미지도 화면 높이에 맞춰 정사각형으로 설정 (예시)
                .frame(width: geometry.size.height, height: geometry.size.height)
                .clipped()
        }
        // 이 뷰 자체의 높이를 화면 높이로 설정
        .frame(height: geometry.size.height)
        // 더 이상 PreferenceKey를 통한 크기 측정은 필요 없으므로 background 로직 제거
    }
}

//#Preview(traits: .landscapeLeft) {
//    ScrollView(.horizontal, showsIndicators: false) {
//        LogAndEndingView()
//    }
//    .onAppear {
//        UIScrollView.appearance().bounces = false
//    }
//}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
