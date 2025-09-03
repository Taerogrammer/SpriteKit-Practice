//
//  LogView.swift
//  swiftui-animation-practice
//
//  Created by 김태형 on 9/2/25.
//

import SwiftUI

struct LogContainerView: View {
    @State private var questions: [QuestionDTO]?

    let logCount: Int
    let size: CGFloat
    let spacing: CGFloat
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(1...logCount, id: \.self) { index in
                LogView(text: String(index), type: .subject, size: size)
            }
            .onAppear {
                loadQuestions()
            }
        }
    }
    
    // MARK: - JSON 로드 로직
    private func loadQuestions() {
        guard let url = Bundle.main.url(forResource: "questions", withExtension: "json") else {
            print("Error: questions.json 파일을 찾을 수 없습니다.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let response = try QuestionsResponse.from(jsonData: data)
            self.questions = response.questions
            print("Response:", response)
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
}

struct LogView: View {
    let text: String
    let type: LogType
    let size: CGFloat // 이제 height 기준

    @State private var currentImageIndex = 0
    private let questionImageNames = ["blank_1", "blank_2"]
    private let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            switch type {
            case .subject:
                // 통나무 - 실제 비율 적용
                Image("log")
                    .frame(
                        width: size * GameConstants.logImageAspectRatio,
                        height: size
                    )

            case .beVerb:
                // 통나무 - 실제 비율 적용
                Image("leaf")
                    .frame(
                        width: size * GameConstants.logImageAspectRatio,
                        height: size
                    )
            case .question:
                // 통나무 - 실제 비율 적용
                Image(questionImageNames[currentImageIndex])
                    .resizable()
                    .scaledToFit()
                    .frame(height: size)
                    // 타이머로부터 이벤트를 받을 때마다 currentImageIndex 변경
                    .onReceive(timer) { _ in
                        currentImageIndex = (currentImageIndex + 1) % questionImageNames.count
                    }
            }
            Text(text)
                .font(.system(size: size * 0.3))
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}

enum LogType {
    case subject    // 주어
    case beVerb     // be동사
    case question   // 맞춰야 하는 것
}

#Preview(traits: .landscapeLeft) {
    LogView(text: "IT", type: .question, size: 160)
}
