//
//  UnmemorizedWordListStateSpy.swift
//  DomainUnitTests
//
//  Created by Jaewon Yun on 2023/09/09.
//

import Combine
import Domain
import Foundation
import State

final class UnmemorizedWordListStateSpy: UnmemorizedWordListStateProtocol {
    
    var _state: UnmemorizedWordListState = .init()
    
    var storedWords: [Word] = []
    
    var currentWord: AnyPublisher<Domain.Word?, Never> {
        fatalError("Not implemented.")
    }
    
    func updateToNextWord() {
        _state.updateToNextWord()
    }
    
    func updateToPreviousWord() {
        _state.updateToPreviousWord()
    }
    
    func addWord(_ word: Domain.Word) {
        _state.addWord(word)
        storedWords.append(word)
    }
    
    func deleteWord(_ word: Domain.Word) {
        _state.deleteWord(word)
        if let index = storedWords.firstIndex(where: { $0.uuid == word.uuid }) {
            storedWords.remove(at: index)
        }
    }
    
    func updateWord(with uuid: UUID, to newWord: Domain.Word) {
        _state.updateWord(with: uuid, to: newWord)
        if let index = storedWords.firstIndex(where: { $0.uuid == uuid }) {
            storedWords[index] = newWord
        }
    }
    
    func randomizeList(with unmemorizedList: [Domain.Word]) {
        _state.randomizeList(with: unmemorizedList)
        guard
            storedWords.count > 1,
            let oldFirstElement = storedWords.first
        else {
            return
        }
        repeat {
            storedWords.shuffle()
        } while storedWords.first ?? .init(word: "") == oldFirstElement
    }
    
    func contains(where predicate: (Domain.Word) -> Bool) -> Bool {
        _state.contains(where: predicate)
    }
    
}
