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
           ScrollViewReader { proxy in
               ScrollView(.horizontal, showsIndicators: false) {
                   ZStack(alignment: .leading) {
                       Image("bg")
                           .resizable()
                           .scaledToFill()
                           .frame(width: 280 + logEndingViewSize.width,
                                  height: geometry.size.height,
                                  alignment: .leading)
                           .clipped()
                           .id("background")
                       
                       LogAndEndingView()
                           .padding(.leading, 280)
                           .id("ending")
                           .onPreferenceChange(SizePreferenceKey.self) { size in
                               logEndingViewSize = size
                           }
                   }
                   .frame(width: 280 + logEndingViewSize.width)
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
