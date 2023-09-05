//
//  WordUseCase.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Foundation

public final class WordUseCase: WordUseCaseProtocol {

    let wordRepository: WordRepositoryProtocol

    public init(wordRepository: WordRepositoryProtocol) {
        self.wordRepository = wordRepository
    }

    public func addNewWord(_ word: Word) {
        wordRepository.save(word)
    }

    public func deleteWord(_ word: Word) {
        wordRepository.delete(word)
    }

    public func getWordList() -> [Word] {
        wordRepository.getAll()
    }

    public func editWord(_ word: Word) {
        wordRepository.update(word)
    }

    public func shuffleUnmemorizedWordList() {
        fatalError("Not implement yet.")
    }

}
