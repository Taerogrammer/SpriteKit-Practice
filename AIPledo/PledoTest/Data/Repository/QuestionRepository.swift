//
//  QuestionRepository.swift
//  PledoTest
//
//  Created by 이중엽 on 9/3/25.
//

import Foundation

final class QuestionRepository {
    
    func loadJSONData() -> Data? {
        guard let url = Bundle.main.url(forResource: "RiverCrossingGameQuestion", withExtension: "json") else {
            print("Error: RiverCrossingGameQuestion.json not found in bundle.")
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print("Error loading data from file: \(error)")
            return nil
        }
    }
    
    func fetchQuestions() async throws -> [QuestionEntity] {
        guard let jsonData = loadJSONData() else { return [] }
        
        let questionDTO = try JSONDecoder().decode(QuestionDTO.self, from: jsonData)
        
        return questionDTO.questions.map { $0.toEntity() }
    }
}
