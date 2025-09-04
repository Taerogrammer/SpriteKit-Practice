//
//  QuestionDTO.swift
//  PledoTest
//
//  Created by 이중엽 on 9/3/25.
//

import Foundation

struct QuestionDTO: Decodable {
    let questions: [QuestionDetailDTO]
}
