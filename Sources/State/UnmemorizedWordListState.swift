//
//  UnmemorizedWordListState.swift
//  StateStore
//
//  Created by Jaewon Yun on 2023/09/06.
//

import Combine
import Domain
import Foundation
import Utility

public struct UnmemorizedWordListState: UnmemorizedWordListStateProtocol {

    let unmemorizedWordList: CurrentValueSubject<CircularLinkedList<Domain.Word>, Never>

    public var currentWord: AnyPublisher<Word?, Never>

    public init() {
        self.unmemorizedWordList = .init(.init())
        currentWord = unmemorizedWordList.map(\.current).eraseToAnyPublisher()
    }

    public func updateToNextWord() {
        unmemorizedWordList.value.next()
    }

    public func updateToPreviousWord() {
        unmemorizedWordList.value.previous()
    }

    public func addWord(_ word: Domain.Word) {
        unmemorizedWordList.value.append(word)
    }

    public func deleteWord(_ word: Domain.Word) {
        unmemorizedWordList.value.delete(word)
    }

    public func updateWord(with uuid: UUID, to newWord: Word) {
        guard let updateTarget = unmemorizedWordList.value.first(where: { $0.uuid == uuid }) else { return }
        unmemorizedWordList.value.replace(updateTarget, to: newWord)
    }

    public func randomizeList(with unmemorizedList: [Domain.Word]) {
        var newList: CircularLinkedList<Word> = .init(unmemorizedList.shuffled())
        if let oldCurrentWord = unmemorizedWordList.value.current,
           let newCurrentWord = newList.current,
           newCurrentWord == oldCurrentWord {
            newList.next()
        }
        unmemorizedWordList.send(newList)
    }

}
