//
//  LogView.swift
//  swiftui-animation-practice
//
//  Created by 김태형 on 9/3/25.
//

import SwiftUI

struct LogView: View {
    let entity: LogEntity

    @State private var currentImageIndex = 0
    private let questionImageNames = ["blank_1", "blank_2"]
    private let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    private var imageName: String {
        switch entity.type {
        case .subject: return "log"
        case .beVerb: return "leaf"
        case .question: return questionImageNames[currentImageIndex]
        }
    }

    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .frame(height: UIScreen.main.bounds.height / 4)
                .scaledToScreen()
                .onReceive(timer) { _ in
                    if entity.type == .question {
                        currentImageIndex = (currentImageIndex + 1) % questionImageNames.count
                    }
                }
            
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
