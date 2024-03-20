//
//  WordService.swift
//  Domain_Notification
//
//  Created by Jaewon Yun on 3/19/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Foundation

public final class WordService {
    
    let wordRepository: WordRepositoryProtocol
    let unmemorizedWordListRepository: UnmemorizedWordListRepositoryProtocol
    let wordDuplicateSpecification: WordDuplicateSpecification
    
    init(wordRepository: WordRepositoryProtocol, unmemorizedWordListRepository: UnmemorizedWordListRepositoryProtocol, wordDuplicateSpecification: WordDuplicateSpecification) {
        self.wordRepository = wordRepository
        self.unmemorizedWordListRepository = unmemorizedWordListRepository
        self.wordDuplicateSpecification = wordDuplicateSpecification
    }

    public func addNewWord(_ word: String) throws {
        let newWordEntity = try Word(word: word)
        
        guard wordDuplicateSpecification.isSatisfied(for: newWordEntity) else {
            throw WordServiceError.saveFailed(reason: .duplicatedWord(word: word))
        }

        try wordRepository.save(newWordEntity)
        unmemorizedWordListRepository.addWord(newWordEntity)
    }

    public func deleteWord(by uuid: UUID) throws {
        try wordRepository.deleteWord(by: uuid)
        unmemorizedWordListRepository.deleteWord(by: uuid)
    }

    public func fetchWordList() -> [Word] {
        return wordRepository.getAllWords()
    }

    public func fetchUnmemorizedWordList() -> [Word] {
        return wordRepository.getUnmemorizedList()
    }

    public func fetchMemorizedWordList() -> [Word] {
        return wordRepository.getMemorizedList()
    }

    public func fetchWord(by uuid: UUID) -> Word? {
        return wordRepository.getWord(by: uuid)
    }

    public func updateWordState(to newState: MemorizedState, uuid: UUID) throws {
        guard let word = wordRepository.getWord(by: uuid) else {
            throw WordServiceError.retrieveFailed(reason: .uuidInvalid(uuid: uuid))
        }
        
        word.memorizedState = newState
        
        try wordRepository.save(word)
        
        switch newState {
        case .memorized:
            if unmemorizedWordListRepository.contains(where: { $0.uuid == uuid }) {
                unmemorizedWordListRepository.deleteWord(by: uuid)
            }
        case .memorizing:
            if !unmemorizedWordListRepository.contains(where: { $0.uuid == uuid }) {
                unmemorizedWordListRepository.addWord(word)
            }
        }
    }
    
    public func updateWordString(to newWordString: String, uuid: UUID) throws {
        guard let word = wordRepository.getWord(by: uuid) else {
            throw WordServiceError.retrieveFailed(reason: .uuidInvalid(uuid: uuid))
        }
        
        try word.setWord(newWordString)
        
        guard wordDuplicateSpecification.isSatisfied(for: word) else {
            throw WordServiceError.saveFailed(reason: .duplicatedWord(word: newWordString))
        }
        
        try wordRepository.save(word)
        
        if unmemorizedWordListRepository.contains(where: { $0.uuid == uuid }) {
            unmemorizedWordListRepository.replaceWord(where: uuid, with: word)
        }
    }

    public func shuffleUnmemorizedWordList() {
        let unmemorizedList = wordRepository.getUnmemorizedList()
        unmemorizedWordListRepository.shuffle(with: unmemorizedList)
    }

    public func updateToNextWord() {
        unmemorizedWordListRepository.updateToNextWord()
    }

    public func updateToPreviousWord() {
        unmemorizedWordListRepository.updateToPreviousWord()
    }

    public func markCurrentWordAsMemorized() throws {
        guard let currentWord = unmemorizedWordListRepository.getCurrentWord() else {
            return
        }
        
        currentWord.memorizedState = .memorized
        
        try wordRepository.save(currentWord)
        unmemorizedWordListRepository.deleteWord(by: currentWord.uuid)
    }

    public func getCurrentUnmemorizedWord() -> Word? {
        return unmemorizedWordListRepository.getCurrentWord()
    }

    public func isWordDuplicated(_ word: String) throws -> Bool {
        let tempEntity = try Word(word: word)
        return wordDuplicateSpecification.isSatisfied(for: tempEntity) ? false : true
    }
    
    public func reset(to newWordList: [Word]) throws {
        try wordRepository.reset(to: newWordList)
    }
}
