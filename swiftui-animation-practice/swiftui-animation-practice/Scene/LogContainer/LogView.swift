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
                .frame(height: UIScreen.main.bounds.height / 4)
                .scaledToScreen()

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
