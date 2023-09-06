//
//  WordStateProtocol.swift
//  StateStore
//
//  Created by Jaewon Yun on 2023/09/06.
//

import Combine

public protocol UnmemorizedWordListStateProtocol {

    var currentWord: AnyPublisher<Word?, Never> { get }

    func updateToNextWord()

    func updateToPreviousWord()

    func addWord(_ word: Word)

    func deleteWord(_ word: Word)

    func updateWord(with uuid: UUID, to newWord: Word)

    func randomizeList(with unmemorizedList: [Word])

}
