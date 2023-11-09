//
//  WordUseCase.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Foundation

public final class WordUseCase: WordUseCaseProtocol {

    let wordRepository: WordRepositoryProtocol

    let unmemorizedWordListState: UnmemorizedWordListStateProtocol

    public init(wordRepository: WordRepositoryProtocol, unmemorizedWordListState: UnmemorizedWordListStateProtocol) {
        self.wordRepository = wordRepository
        self.unmemorizedWordListState = unmemorizedWordListState
    }

    public func addNewWord(_ word: Word) {
        if word.memorizedState == .memorized {
            assertionFailure("Added a already memorized word.")
        }

        unmemorizedWordListState.addWord(word)
        wordRepository.save(word)
    }

    public func deleteWord(by uuid: UUID) {
        unmemorizedWordListState.deleteWord(by: uuid)
        wordRepository.delete(by: uuid)
    }

    public func getWordList() -> [Word] {
        return wordRepository.getAll()
    }

    public func getMemorizedWordList() -> [Word] {
        return wordRepository.getMemorizedList()
    }

    public func getUnmemorizedWordList() -> [Word] {
        return wordRepository.getUnmemorizedList()
    }

    public func getWord(by uuid: UUID) -> Word? {
        return wordRepository.get(by: uuid)
    }

    public func updateWord(by uuid: UUID, to newWord: Word) {
        let updateTarget: Word = .init(
            uuid: uuid,
            word: newWord.word,
            memorizedState: newWord.memorizedState
        )
        
        if unmemorizedWordListState.contains(where: { $0.uuid == updateTarget.uuid }) {
            if updateTarget.memorizedState == .memorized {
                unmemorizedWordListState.deleteWord(by: uuid)
            }
            unmemorizedWordListState.replaceWord(where: uuid, with: updateTarget)
        } else if updateTarget.memorizedState == .memorizing {
            unmemorizedWordListState.addWord(updateTarget)
        }
        
        wordRepository.save(updateTarget)
    }

    public func randomizeUnmemorizedWordList() {
        let unmemorizedList = wordRepository.getUnmemorizedList()
        unmemorizedWordListState.randomizeList(with: unmemorizedList)
    }

    public func updateToNextWord() {
        unmemorizedWordListState.updateToNextWord()
    }

    public func updateToPreviousWord() {
        unmemorizedWordListState.updateToPreviousWord()
    }

    public func markCurrentWordAsMemorized(uuid: UUID) {
        guard let currentWord = wordRepository.get(by: uuid) else {
            return
        }

        currentWord.memorizedState = .memorized

        unmemorizedWordListState.deleteWord(by: uuid)
        wordRepository.save(currentWord)
    }

    public var currentUnmemorizedWord: Word? {
        unmemorizedWordListState.getCurrentWord()
    }

}
