//
//  QuestionDTO.swift
//  swiftui-animation-practice
//
//  Created by 김태형 on 9/3/25.
//

import Foundation

struct QuestionDTO: Decodable {
    let answerLC: String
    let answerUC: String
    let blockConnectionType: String
    let categoryDetailNo: String
    let categoryKR: String
    let categoryUS: String
    let difficulty: Int
    let explanation: String
    let fullTextLC: String
    let fullTextUC: String
    let gameType: String
    let hint: String
    let keyword1: String
    let keyword2: String
    let keyword3: String
    let keyword4: String
    let level: Int
    let questionLC: String
    let questionNo: Int
    let questionText: String
    let questionType: String
    let questionUC: String
    let questionUuid: String
    let sentenceMeaning: String
    let sentenceMeaningCN: String
    
    // BE 동사 목록
    static let beVerbs = ["AM", "IS", "ARE", "WAS", "WERE", "BEEN", "BEING", "BE"]

    /// `questionUC`에서 괄호와 '/'를 제거하고 단어들을 배열로 반환하는 메서드
    func parsedQuestionText() -> [String] {
        let cleanedString = self.questionUC
            .replacingOccurrences(of: "(", with: " ")
            .replacingOccurrences(of: ")", with: " ")
            .replacingOccurrences(of: "/", with: " ")
        
        // 공백을 기준으로 문자열을 분리하고 빈 문자열을 제거
        return cleanedString
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
    }
    
    /// `questionUC`를 파싱해서 TextResponse 배열로 반환하는 메서드
    func parseToTextResponses() -> [LogEntity] {
        var textResponses: [LogEntity] = []
        let questionUC = self.questionUC
        var currentIndex = questionUC.startIndex
        
        while currentIndex < questionUC.endIndex {
            if questionUC[currentIndex] == "(" {
                guard let closeParenIndex = questionUC[currentIndex...].firstIndex(of: ")") else {
                    break
                }
                
                // 괄호 안의 내용 추출
                let startIndex = questionUC.index(after: currentIndex)
                let bracketContent = String(questionUC[startIndex..<closeParenIndex])
                
                // '/'로 분리된 단어들 처리
                let options = bracketContent.components(separatedBy: "/")
                for option in options {
                    let trimmedOption = option.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !trimmedOption.isEmpty {
                        textResponses.append(LogEntity(type: .question, word: trimmedOption))
                    }
                }
                
                currentIndex = questionUC.index(after: closeParenIndex)
            } else {
                // 일반 단어 처리
                var wordEndIndex = currentIndex
                
                // 다음 괄호나 문자열 끝까지 찾기
                while wordEndIndex < questionUC.endIndex && questionUC[wordEndIndex] != "(" {
                    wordEndIndex = questionUC.index(after: wordEndIndex)
                }
                
                let wordSection = String(questionUC[currentIndex..<wordEndIndex])
                
                // 공백으로 분리해서 개별 단어 처리
                let words = wordSection
                    .components(separatedBy: .whitespacesAndNewlines)
                    .filter { !$0.isEmpty }
                
                for word in words {
                    let cleanWord = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
                    if !cleanWord.isEmpty {
                        let type: LogType = Self.beVerbs.contains(cleanWord.uppercased()) ? .beVerb : .subject
                        textResponses.append(LogEntity(type: type, word: cleanWord))
                    }
                }
                
                currentIndex = wordEndIndex
            }
        }
        
        return textResponses
    }
}

struct LogEntity {
    var type: LogType
    let word: String
}

// MARK: - QuestionsResponse
struct QuestionsResponse: Decodable {
    let questions: [QuestionDTO]
}

// MARK: - JSON 처리 유틸리티
extension QuestionsResponse {
    // JSON 데이터에서 QuestionsResponse 파싱
    static func from(jsonData: Data) throws -> QuestionsResponse {
        let decoder = JSONDecoder()
        return try decoder.decode(QuestionsResponse.self, from: jsonData)
    }
    
    // JSON 문자열에서 QuestionsResponse 파싱
    static func from(jsonString: String) throws -> QuestionsResponse {
        guard let data = jsonString.data(using: .utf8) else {
            throw NSError(domain: "InvalidJSON", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON string"])
        }
        return try from(jsonData: data)
    }
}
