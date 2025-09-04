//
//  ContentView.swift
//  swiftui-animation-practice
//
//  Created by 김태형 on 9/3/25.
//

import SwiftUI

struct ContentView: View {
   @State private var logEndingViewSize: CGSize = .zero
   
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
               .clipped()
           }
           .onAppear {
               UIScrollView.appearance().bounces = false
           }
       }
       .ignoresSafeArea()
   }
}

#Preview(traits: .landscapeLeft) {
    ContentView()
}
