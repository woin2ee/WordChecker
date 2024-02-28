//
//  WordDuplicateSpecification.swift
//  Domain
//
//  Created by Jaewon Yun on 2/18/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import RxSwift

final class WordDuplicateSpecification: Specification {

    private let wordRepository: WordRepositoryProtocol

    init(wordRepository: WordRepositoryProtocol) {
        self.wordRepository = wordRepository
    }

    /// 단어가 중복이 아니면 `true` 를 반환합니다.
    ///
    /// 대소문자가 다른 단어는 같은 단어로 취급합니다.
    ///
    /// - Note: UUID 가 동일한 Entity 는 하나의 Entity 이므로 중복으로 인식되지 않습니다.
    func isSatisfied(for entity: Word) -> Bool {
        if let originWord = wordRepository.getWord(by: entity.uuid) {
            // Entity 가 이미 있을때는 업데이트 상황이므로 만약 중복 단어가 존재한다면 추가로 자기 자신 Entity 가 아닌지 확인이 필요합니다.
            if wordRepository.getWords(by: entity.word).hasElements &&
                (originWord.word.lowercased() != entity.word.lowercased()) {
                return false
            } else {
                return true
            }
        }

        return wordRepository.getWords(by: entity.word).isEmpty
    }
}
