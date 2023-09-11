//
//  WordStateProtocol.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/06.
//

import Combine

public protocol UnmemorizedWordListStateProtocol {

    var currentWord: AnyPublisher<Word?, Never> { get }

    func updateToNextWord()

    func updateToPreviousWord()

    func addWord(_ word: Word)

    func deleteWord(with uuid: UUID)

    func replaceWord(where uuid: UUID, with newWord: Word)

    func randomizeList(with unmemorizedList: [Word])

    func contains(where predicate: (Word) -> Bool) -> Bool

}
