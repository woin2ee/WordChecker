//
//  WordDuplicateSpecification.swift
//  Domain
//
//  Created by Jaewon Yun on 2/18/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import RxSwift

/// 단어가 중복되면 안됩니다.
///
/// 대소문자가 다른 단어는 같은 단어로 취급합니다.
///
/// - Note: UUID 가 동일한 Entity 는 하나의 Entity 이므로 중복으로 인식되지 않습니다.
struct WordDuplicateSpecification: Specification {

    private let wordRepository: WordRepositoryProtocol

    init(wordRepository: WordRepositoryProtocol) {
        self.wordRepository = wordRepository
    }

    func isSatisfied(for entity: Word) -> Bool {
        if let originWord = wordRepository.getWord(by: entity.uuid) {
            let allWords = wordRepository.getAllWords()
            if (originWord.word.lowercased() != entity.word.lowercased()) &&
                allWords.contains(where: { $0.word.lowercased() == entity.word.lowercased() }) {
                return false
            } else {
                return true
            }
        }

        let allWords = wordRepository.getAllWords()
        if allWords.contains(where: { $0.word.lowercased() == entity.word.lowercased() }) {
            return false
        } else {
            return true
        }
    }
}
