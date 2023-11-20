//
//  UnmemorizedWordListState.swift
//  State
//
//  Created by Jaewon Yun on 2023/09/06.
//

import Domain
import Foundation
import Utility

final class UnmemorizedWordListRepository: UnmemorizedWordListRepositoryProtocol {

    private(set) var unmemorizedWordList: CircularLinkedList<Domain.Word>

    init() {
        self.unmemorizedWordList = .init()
    }

    func updateToNextWord() {
        unmemorizedWordList.next()
    }

    func updateToPreviousWord() {
        unmemorizedWordList.previous()
    }

    func addWord(_ word: Domain.Word) {
        unmemorizedWordList.append(word)
    }

    func deleteWord(by uuid: UUID) {
        guard let targetIndex = unmemorizedWordList.firstIndex(where: { $0.uuid == uuid }) else {
            return
        }

        unmemorizedWordList.remove(at: targetIndex)
    }

    func replaceWord(where uuid: UUID, with newWord: Domain.Word) {
        guard let targetIndex = unmemorizedWordList.firstIndex(where: { $0.uuid == uuid }) else {
            return
        }

        unmemorizedWordList[targetIndex] = newWord
    }

    func randomizeList(with unmemorizedList: [Domain.Word]) {
        var newList: CircularLinkedList<Domain.Word> = .init(unmemorizedList.shuffled())
        if let oldCurrentWord = unmemorizedWordList.current,
           let newCurrentWord = newList.current,
           newCurrentWord == oldCurrentWord {
            newList.next()
        }
        unmemorizedWordList = newList
    }

    func contains(where predicate: (Domain.Word) -> Bool) -> Bool {
        return unmemorizedWordList.contains(where: predicate)
    }

    func getCurrentWord() -> Domain.Word? {
        return unmemorizedWordList.current
    }

}
