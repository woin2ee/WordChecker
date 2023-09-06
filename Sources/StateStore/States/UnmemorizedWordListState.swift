//
//  UnmemorizedWordListState.swift
//  StateStore
//
//  Created by Jaewon Yun on 2023/09/06.
//

import Domain
import Foundation

struct UnmemorizedWordListState: State {

    var shuffledWordList: CircularLinkedList<Word> = .init()

    public var currentWord: Word?

}
