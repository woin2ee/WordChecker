//
//  UnmemorizedWordListStateSpy.swift
//  iOSCoreUnitTests
//
//  Created by Jaewon Yun on 2023/09/13.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Combine
import Domain
import Foundation
import State

public final class UnmemorizedWordListStateSpy: UnmemorizedWordListStateProtocol {

    public var _state: UnmemorizedWordListState = .init()

    public var _storedWords: [Word] = []

    public init() {}

    public var currentWord: AnyPublisher<Domain.Word?, Never> {
        fatalError("Not implemented.")
    }

    public func updateToNextWord() {
        _state.updateToNextWord()
    }

    public func updateToPreviousWord() {
        _state.updateToPreviousWord()
    }

    public func addWord(_ word: Domain.Word) {
        _state.addWord(word)
        _storedWords.append(word)
    }

    public func deleteWord(by uuid: UUID) {
        _state.deleteWord(by: uuid)
        if let index = _storedWords.firstIndex(where: { $0.uuid == uuid }) {
            _storedWords.remove(at: index)
        }
    }

    public func replaceWord(where uuid: UUID, with newWord: Domain.Word) {
        _state.replaceWord(where: uuid, with: newWord)
        if let index = _storedWords.firstIndex(where: { $0.uuid == uuid }) {
            _storedWords[index] = newWord
        }
    }

    public func randomizeList(with unmemorizedList: [Domain.Word]) {
        _state.randomizeList(with: unmemorizedList)
        guard
            _storedWords.count > 1,
            let oldFirstElement = _storedWords.first
        else {
            return
        }
        repeat {
            _storedWords.shuffle()
        } while _storedWords.first ?? .init(word: "") == oldFirstElement
    }

    public func contains(where predicate: (Domain.Word) -> Bool) -> Bool {
        _state.contains(where: predicate)
    }

}
