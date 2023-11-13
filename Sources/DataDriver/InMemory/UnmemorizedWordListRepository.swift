//
//  UnmemorizedWordListState.swift
//  State
//
//  Created by Jaewon Yun on 2023/09/06.
//

import Domain
import Foundation
import Utility

public final class UnmemorizedWordListRepository: UnmemorizedWordListRepositoryProtocol {

    private(set) var unmemorizedWordList: CircularLinkedList<Domain.Word>

    public init() {
        self.unmemorizedWordList = .init()
    }

    public func updateToNextWord() {
        unmemorizedWordList.next()
    }

    public func updateToPreviousWord() {
        unmemorizedWordList.previous()
    }

    public func addWord(_ word: Domain.Word) {
        unmemorizedWordList.append(word)
    }

    public func deleteWord(by uuid: UUID) {
        guard let targetIndex = unmemorizedWordList.firstIndex(where: { $0.uuid == uuid }) else {
            return
        }

        unmemorizedWordList.remove(at: targetIndex)
    }

    public func replaceWord(where uuid: UUID, with newWord: Domain.Word) {
        guard let targetIndex = unmemorizedWordList.firstIndex(where: { $0.uuid == uuid }) else {
            return
        }

        unmemorizedWordList[targetIndex] = newWord
    }

    public func randomizeList(with unmemorizedList: [Domain.Word]) {
        var newList: CircularLinkedList<Domain.Word> = .init(unmemorizedList.shuffled())
        if let oldCurrentWord = unmemorizedWordList.current,
           let newCurrentWord = newList.current,
           newCurrentWord == oldCurrentWord {
            newList.next()
        }
        unmemorizedWordList = newList
    }

    public func contains(where predicate: (Domain.Word) -> Bool) -> Bool {
        return unmemorizedWordList.contains(where: predicate)
    }

    public func getCurrentWord() -> Domain.Word? {
        return unmemorizedWordList.current
    }

}
