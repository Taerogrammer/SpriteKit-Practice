//
//  ContentView.swift
//  swiftui-animation-practice
//
//  Created by 김태형 on 9/3/25.
//

import SwiftUI

struct ContentView: View {
   @State private var logEndingViewSize: CGSize = .zero
    @State private var isAnimating = false
   
   var body: some View {
       GeometryReader { geometry in
           let paddingRatio: CGFloat = 0.2
           let leadingPadding = geometry.size.width * paddingRatio
           
           ScrollViewReader { proxy in
               ScrollView(.horizontal, showsIndicators: false) {
                   ZStack(alignment: .leading) {
                       Image("bg")
                           .resizable()
                           .scaledToFill()
                           .frame(width: leadingPadding + logEndingViewSize.width,
                                  alignment: .leading)
                           .clipped()
                           .id("background")
                       
                       LogAndEndingView()
                           .padding(.leading, leadingPadding)
                           .id("ending")
                           .onPreferenceChange(SizePreferenceKey.self) { size in
                               logEndingViewSize = size
                           }
                   }
                   .frame(width: leadingPadding + logEndingViewSize.width)
               }
               .allowsHitTesting(!isAnimating)
               .clipped()
               .onAppear {
                   UIScrollView.appearance().bounces = false
                   
                   isAnimating = true
                
                   Task {
                       // 0.5초 대기
                       try await Task.sleep(nanoseconds: 500_000_000)
                       
                       // 첫 번째 스크롤 애니메이션 (오른쪽으로)
                       withAnimation(.easeOut(duration: 1.5)) {
                           proxy.scrollTo("ending", anchor: .trailing)
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
       .ignoresSafeArea()
   }
}

#Preview(traits: .landscapeLeft) {
    ContentView()
}
