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
            isMemorized: newWord.isMemorized
        )
        if unmemorizedWordListState.contains(where: { $0.uuid == updateTarget.uuid }) {
            if updateTarget.isMemorized {
                unmemorizedWordListState.deleteWord(by: uuid)
            }
            unmemorizedWordListState.replaceWord(where: uuid, with: updateTarget)
        } else if !updateTarget.isMemorized {
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

        currentWord.isMemorized = true

        unmemorizedWordListState.deleteWord(by: uuid)
        wordRepository.save(currentWord)
    }

}
