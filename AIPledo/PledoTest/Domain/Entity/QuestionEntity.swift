//
//  QuestionEntity.swift
//  PledoTest
//
//  Created by 이중엽 on 9/3/25.
//

import Foundation

enum QuestionTextType: Hashable, Identifiable {
    var id: UUID { UUID() }
    
    case normal(String)
    case question([String])
}

struct QuestionEntity: Hashable, Identifiable {
    let id: String = UUID().uuidString
    let level: Int                                  // 1
    let answer: String                              // "I AM HAPPY"
    let fullText: String                            // "I AM HAAPY."
    let fullTextKorean: String                      // "나는 기쁘다."
    let sentenceQuestionText: [QuestionTextType]    // [normal("I"), question(["AM", "ARE"]), normal("HAPPY.")] -> 구두 점 유지
    let tokenQuestionText: [QuestionTextType]       // [normal("I"), question(["AM", "ARE"]), normal("HAPPY")] -> 구두 점 없음
    
    static func == (lhs: QuestionEntity, rhs: QuestionEntity) -> Bool {
        return lhs.id == rhs.id
    }
}
