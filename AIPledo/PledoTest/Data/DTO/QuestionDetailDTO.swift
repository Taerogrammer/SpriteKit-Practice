//
//  QuestionDetailDTO.swift
//  PledoTest
//
//  Created by 이중엽 on 9/3/25.
//

import Foundation

struct QuestionDetailDTO: Decodable {
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
    
    func toEntity() -> QuestionEntity {
        let sentenceQuestionText = parseQuestion(questionLC)
        let tokenQuestionText = parseQuestionWithoutPunctuation(questionLC)
        
        return QuestionEntity(level: level, answer: answerLC, fullText: fullTextLC, fullTextKorean: sentenceMeaning, sentenceQuestionText: sentenceQuestionText, tokenQuestionText: tokenQuestionText)
    }
    
    func parseQuestion(_ text: String) -> [QuestionTextType] {
        var result: [QuestionTextType] = []
        
        // 공백 단위로 자르기
        let components = text.components(separatedBy: " ")
        
        for comp in components {
            if comp.hasPrefix("("), comp.contains(")") {
                // 괄호 닫힌 위치 찾기
                if let closingIndex = comp.firstIndex(of: ")") {
                    let beforeClosing = comp[comp.startIndex...closingIndex] // "(HAPPY/ANGRY)"
                    let afterClosing = comp[comp.index(after: closingIndex)...] // "."
                    
                    // 괄호 안쪽 파싱
                    let inner = beforeClosing.dropFirst().dropLast() // "HAPPY/ANGRY"
                    let options = inner.components(separatedBy: "/")
                    result.append(.question(options))
                }
            } else {
                // 일반 단어
                result.append(.normal(comp))
            }
        }
        
        return result
    }
    
    // MARK: - 구두점 제거 버전
    func parseQuestionWithoutPunctuation(_ text: String) -> [QuestionTextType] {
        var result: [QuestionTextType] = []
        
        // 알파벳과 괄호만 남기고 제거
        let cleanedText = text.map { char -> Character in
            if char.isLetter || char == "(" || char == ")" || char == " " || char == "/" {
                return char
            } else {
                return " "
            }
        }.reduce("") { $0 + String($1) }
        
        let components = cleanedText.components(separatedBy: " ")
        
        for comp in components where !comp.isEmpty {
            if comp.hasPrefix("("), comp.contains(")") {
                if let closingIndex = comp.firstIndex(of: ")") {
                    let inner = comp[comp.index(after: comp.startIndex)..<closingIndex]
                    let options = inner.components(separatedBy: "/")
                    result.append(.question(options))
                }
            } else {
                result.append(.normal(comp))
            }
        }
        
        return result
    }
}
