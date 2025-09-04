//
//  LogView.swift
//  swiftui-animation-practice
//
//  Created by 김태형 on 9/3/25.
//

import SwiftUI

struct LogView: View {
    let entity: LogEntity
    var body: some View {
        ZStack {
            Image("log")
                .resizable()
                .frame(height: UIScreen.main.bounds.height / 4)
                .scaledToScreen()

            Text(entity.word)
                .font(.system(size: UIScreen.main.bounds.height / 16, weight: .bold, design: .default))
                .foregroundColor(.white)
                .scaledToScreen()
        }
    }
}

#Preview(traits: .landscapeLeft) {
    LogView(entity: LogEntity(type: .beVerb, word: "AN"))
}
