//
//  LogView.swift
//  swiftui-animation-practice
//
//  Created by 김태형 on 9/2/25.
//

import SwiftUI

struct LogView: View {
    var body: some View {
        HStack(spacing: 12) {
            Image("log")
            Image("log")
            Image("log")
        }
        .padding(.leading, 40)
    }
}

#Preview(traits: .landscapeLeft) {
    LogView()
}
