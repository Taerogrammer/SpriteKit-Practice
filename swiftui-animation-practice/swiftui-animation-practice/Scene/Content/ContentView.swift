//
//  ContentView.swift
//  swiftui-animation-practice
//
//  Created by 김태형 on 9/3/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ZStack(alignment: .leading) {
                Image("bg")
                    .resizable()
                    .scaledToFill()
                
                LogAndEndingView()
                    .padding(.leading, 280)
            }
        }
        .onAppear {
            UIScrollView.appearance().bounces = false
        }
    }
}

#Preview(traits: .landscapeLeft) {
    ContentView()
}
