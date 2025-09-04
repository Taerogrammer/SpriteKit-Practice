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
        // GeometryReader를 사용해 자신에게 주어진 공간의 크기를 파악합니다.
        GeometryReader { geometry in
            ZStack {
                Image(imageName)
                    .resizable()
                    .scaledToFit() // 프레임에 맞게 비율을 유지하며 채움
                
                Text(entity.word)
                    // 폰트 크기를 부모가 준 높이(geometry.size.height)에 비례하도록 설정
                    .font(.system(size: geometry.size.height / 4, weight: .bold, design: .default))
                    .foregroundColor(.white)
            }
            // ZStack 전체가 주어진 공간을 꽉 채우도록 합니다.
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onReceive(timer) { _ in
                if entity.type == .question {
                    currentImageIndex = (currentImageIndex + 1) % questionImageNames.count
                }
            }
        }
    }
}

#Preview(traits: .landscapeLeft) {
    LogView(entity: LogEntity(type: .beVerb, word: "AN"))
}
