//
//  LogView.swift
//  swiftui-animation-practice
//
//  Created by 김태형 on 9/3/25.
//

import SwiftUI

struct LogView: View {
    var body: some View {
        ZStack {
            Image("log")
                .resizable()
                .scaledToScreen()
                .frame(width: 293, height: 215)
                

            Text("숫자")
                .font(.system(size: 36, weight: .bold, design: .default))
                .foregroundColor(.white)
                .scaledToScreen()
        }
    }
}

#Preview(traits: .landscapeLeft) {
    LogView()
}
