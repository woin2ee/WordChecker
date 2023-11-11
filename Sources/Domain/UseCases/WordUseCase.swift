//
//  WordUseCase.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Foundation

public final class WordUseCase: WordUseCaseProtocol {

    let wordRepository: WordRepositoryProtocol
    let unmemorizedWordListRepository: UnmemorizedWordListRepositoryProtocol

    public init(
        wordRepository: WordRepositoryProtocol,
        unmemorizedWordListRepository: UnmemorizedWordListRepositoryProtocol
    ) {
        self.wordRepository = wordRepository
        self.unmemorizedWordListRepository = unmemorizedWordListRepository
    }

    public func addNewWord(_ word: Word) {
        if word.memorizedState == .memorized {
            assertionFailure("Added a already memorized word.")
        }

        unmemorizedWordListRepository.addWord(word)
        wordRepository.save(word)
    }

    public func deleteWord(by uuid: UUID) {
        unmemorizedWordListRepository.deleteWord(by: uuid)
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

        if unmemorizedWordListRepository.contains(where: { $0.uuid == updateTarget.uuid }) {
            if updateTarget.memorizedState == .memorized {
                unmemorizedWordListRepository.deleteWord(by: uuid)
            }
            unmemorizedWordListRepository.replaceWord(where: uuid, with: updateTarget)
        } else if updateTarget.memorizedState == .memorizing {
            unmemorizedWordListRepository.addWord(updateTarget)
        }

        wordRepository.save(updateTarget)
    }

    public func randomizeUnmemorizedWordList() {
        let unmemorizedList = wordRepository.getUnmemorizedList()
        unmemorizedWordListRepository.randomizeList(with: unmemorizedList)
    }

    public func updateToNextWord() {
        unmemorizedWordListRepository.updateToNextWord()
    }

    public func updateToPreviousWord() {
        unmemorizedWordListRepository.updateToPreviousWord()
    }

    public func markCurrentWordAsMemorized(uuid: UUID) {
        guard let currentWord = wordRepository.get(by: uuid) else {
            return
        }

        currentWord.memorizedState = .memorized

        unmemorizedWordListRepository.deleteWord(by: uuid)
        wordRepository.save(currentWord)
    }

    public var currentUnmemorizedWord: Word? {
        unmemorizedWordListRepository.getCurrentWord()
    }

}
