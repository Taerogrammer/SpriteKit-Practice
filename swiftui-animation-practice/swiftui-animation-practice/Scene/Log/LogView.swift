//
//  LogView.swift
//  swiftui-animation-practice
//
//  Created by 김태형 on 9/2/25.
//

import SwiftUI

struct LogContainerView: View {
    @State private var questions: [QuestionDTO]?
    @State private var currentQuestionIndex: Int = 0
    
    let logCount: Int
    let size: CGFloat
    let spacing: CGFloat
    
    var body: some View {
        Group {
            if let questions = questions, !questions.isEmpty {
                let currentQuestion = questions[currentQuestionIndex]
                let textResponses = currentQuestion.parseToTextResponses()
                
                // TextResponse 배열을 타입별로 그룹화
                let groupedResponses = groupResponsesByType(textResponses)
                
                HStack(spacing: spacing) {
                    ForEach(Array(groupedResponses.enumerated()), id: \.offset) { index, group in
                        if group.first?.type == .question {
                            // question 타입들은 VStack으로 세로 배치
                            VStack(spacing: spacing / 2) {
                                ForEach(Array(group.enumerated()), id: \.offset) { _, response in
                                    LogView(
                                        text: response.word,
                                        type: response.type,
                                        size: size
                                    )
                                }
                            }
                        } else {
                            // subject, beVerb 타입들은 HStack으로 가로 배치
                            HStack(spacing: spacing / 2) {
                                ForEach(Array(group.enumerated()), id: \.offset) { _, response in
                                    LogView(
                                        text: response.word,
                                        type: response.type,
                                        size: size
                                    )
                                }
                            }
                        }
                    }
                }
            } else {
                // 데이터 로딩 중일 때 기본 레이아웃
                HStack(spacing: spacing) {
                    ForEach(1...logCount, id: \.self) { index in
                        LogView(text: String(index), type: .subject, size: size)
                    }
                }
            }
        }
        .onAppear {
            loadQuestions()
        }
    }
    
    // MARK: - TextResponse 배열을 연속된 같은 타입별로 그룹화
    private func groupResponsesByType(_ responses: [TextResponse]) -> [[TextResponse]] {
        guard !responses.isEmpty else { return [] }
        
        var groups: [[TextResponse]] = []
        var currentGroup: [TextResponse] = [responses[0]]
        
        for i in 1..<responses.count {
            if responses[i].type == currentGroup.last?.type {
                // 같은 타입이면 현재 그룹에 추가
                currentGroup.append(responses[i])
            } else {
                // 타입이 바뀌면 현재 그룹을 완성하고 새 그룹 시작
                groups.append(currentGroup)
                currentGroup = [responses[i]]
            }
        }
        
        // 마지막 그룹 추가
        groups.append(currentGroup)
        
        return groups
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
            
            // 첫 번째 질문의 TextResponse 배열 확인
            if let firstQuestion = response.questions.first {
                let textResponses = firstQuestion.parseToTextResponses()
                print("TextResponses:", textResponses.map { "(\($0.type): \($0.word))" })
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    // MARK: - 문제 전환 함수들
    func nextQuestion() {
        guard let questions = questions, !questions.isEmpty else { return }
        currentQuestionIndex = (currentQuestionIndex + 1) % questions.count
    }
    
    func previousQuestion() {
        guard let questions = questions, !questions.isEmpty else { return }
        currentQuestionIndex = currentQuestionIndex > 0 ? currentQuestionIndex - 1 : questions.count - 1
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
                    .frame(
                        width: size * GameConstants.logImageAspectRatio,
                        height: size
                    )
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
    LogContainerView(logCount: 5, size: 180, spacing: 180)
}
