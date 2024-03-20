//
//  UnmemorizedWordListRepositorySpy.swift
//  iOSCoreUnitTests
//
//  Created by Jaewon Yun on 2023/09/13.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain_Word
import Foundation
import Utility

public final class UnmemorizedWordListRepositorySpy: UnmemorizedWordListRepositoryProtocol {

    public var _storedWords: CircularLinkedList<Word> = .init()

    public init() {}

    public func updateToNextWord() {
        _storedWords.next()
    }

    public func updateToPreviousWord() {
        _storedWords.previous()
    }

    public func addWord(_ word: Word) {
        _storedWords.append(word)
    }

    public func deleteWord(by uuid: UUID) {
        if let index = _storedWords.firstIndex(where: { $0.uuid == uuid }) {
            _storedWords.remove(at: index)
        }
    }

    public func replaceWord(where uuid: UUID, with newWord: Word) {
        if let index = _storedWords.firstIndex(where: { $0.uuid == uuid }) {
            _storedWords[index] = newWord
        }
    }

    public func shuffle(with unmemorizedList: [Word]) {
        let oldCurrentElement = _storedWords.current

        _storedWords = .init(unmemorizedList)

        guard _storedWords.count > 1 else {
            return
        }

        repeat {
            _storedWords.shuffle()
        } while _storedWords.current == oldCurrentElement
    }

    public func contains(where predicate: (Word) -> Bool) -> Bool {
        _storedWords.contains(where: predicate)
    }

    public func getCurrentWord() -> Word? {
        _storedWords.current
    }

}
