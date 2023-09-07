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

    public func deleteWord(_ word: Word) {
        unmemorizedWordListState.deleteWord(word)
        wordRepository.delete(word)
    }

    public func getWordList() -> [Word] {
        return wordRepository.getAll()
    }

    public func getWord(with uuid: UUID) -> Word? {
        return wordRepository.get(by: uuid)
    }

    public func updateWord(with uuid: UUID, to newWord: Word) {
        let updateTarget: Word = .init(
            uuid: uuid,
            word: newWord.word,
            isMemorized: newWord.isMemorized
        )
        if unmemorizedWordListState.contains(where: { $0.uuid == updateTarget.uuid }) {
            if updateTarget.isMemorized {
                unmemorizedWordListState.deleteWord(updateTarget)
            }
            unmemorizedWordListState.updateWord(with: uuid, to: updateTarget)
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

}
