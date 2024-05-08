//
//  DefaultWordService.swift
//  Domain_Notification
//
//  Created by Jaewon Yun on 3/19/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Foundation

internal final class DefaultWordService: WordService {

    private let wordRepository: WordRepositoryProtocol
    private let unmemorizedWordListRepository: UnmemorizedWordListRepositoryProtocol
    private let wordDuplicateSpecification: WordDuplicateSpecification

    init(wordRepository: WordRepositoryProtocol, unmemorizedWordListRepository: UnmemorizedWordListRepositoryProtocol, wordDuplicateSpecification: WordDuplicateSpecification) {
        self.wordRepository = wordRepository
        self.unmemorizedWordListRepository = unmemorizedWordListRepository
        self.wordDuplicateSpecification = wordDuplicateSpecification
    }

    func addNewWord(_ word: String) throws {
        let newWordEntity = try Word(word: word)

        guard wordDuplicateSpecification.isSatisfied(for: newWordEntity) else {
            throw WordServiceError.saveFailed(reason: .duplicatedWord(word: word))
        }

        try wordRepository.save(newWordEntity)
        unmemorizedWordListRepository.addWord(newWordEntity)
    }

    func deleteWord(by uuid: UUID) throws {
        try wordRepository.deleteWord(by: uuid)
        unmemorizedWordListRepository.deleteWord(by: uuid)
    }

    func fetchWordList() -> [Word] {
        return wordRepository.getAllWords()
    }

    func fetchUnmemorizedWordList() -> [Word] {
        return wordRepository.getUnmemorizedList()
    }

    func fetchMemorizedWordList() -> [Word] {
        return wordRepository.getMemorizedList()
    }

    func fetchWord(by uuid: UUID) -> Word? {
        return wordRepository.getWord(by: uuid)
    }

    func updateWord(with newAttribute: WordAttribute, id: UUID) throws {
        if newAttribute.word == nil, newAttribute.memorizationState == nil {
            return
        }

        guard var wordEntity = wordRepository.getWord(by: id) else {
            throw WordServiceError.retrieveFailed(reason: .uuidInvalid(uuid: id))
        }

        var isWordUpdated = false
        var isStateUpdated = false

        if let newWord = newAttribute.word {
            try wordEntity.setWord(newWord)
            guard wordDuplicateSpecification.isSatisfied(for: wordEntity) else {
                throw WordServiceError.saveFailed(reason: .duplicatedWord(word: newWord))
            }
            isWordUpdated = true
        }

        if let newState = newAttribute.memorizationState {
            wordEntity.memorizationState = newState
            isStateUpdated = true
        }

        try wordRepository.save(wordEntity)

        if isWordUpdated, isStateUpdated {
            switch wordEntity.memorizationState {
            case .memorized:
                unmemorizedWordListRepository.deleteWord(by: id)
            case .memorizing:
                if !unmemorizedWordListRepository.contains(where: { $0.uuid == id }) {
                    unmemorizedWordListRepository.addWord(wordEntity)
                } else {
                    unmemorizedWordListRepository.replaceWord(where: id, with: wordEntity)
                }
            }
        } else if isWordUpdated {
            unmemorizedWordListRepository.replaceWord(where: id, with: wordEntity)
        } else if isStateUpdated {
            switch wordEntity.memorizationState {
            case .memorized:
                unmemorizedWordListRepository.deleteWord(by: id)
            case .memorizing:
                if !unmemorizedWordListRepository.contains(where: { $0.uuid == id }) {
                    unmemorizedWordListRepository.addWord(wordEntity)
                }
            }
        }
    }

    func shuffleUnmemorizedWordList() {
        let unmemorizedList = wordRepository.getUnmemorizedList()
        unmemorizedWordListRepository.shuffle(with: unmemorizedList)
    }

    func updateToNextWord() {
        unmemorizedWordListRepository.updateToNextWord()
    }

    func updateToPreviousWord() {
        unmemorizedWordListRepository.updateToPreviousWord()
    }

    func markCurrentWordAsMemorized() throws {
        guard var currentWord = unmemorizedWordListRepository.getCurrentWord() else {
            return
        }

        currentWord.memorizationState = .memorized

        try wordRepository.save(currentWord)
        unmemorizedWordListRepository.deleteWord(by: currentWord.uuid)
    }

    func getCurrentUnmemorizedWord() -> Word? {
        return unmemorizedWordListRepository.getCurrentWord()
    }

    func isWordDuplicated(_ word: String) throws -> Bool {
        let tempEntity = try Word(word: word)
        return wordDuplicateSpecification.isSatisfied(for: tempEntity) ? false : true
    }

    func reset(to newWordList: [Word]) throws {
        try wordRepository.reset(to: newWordList)
    }
}
