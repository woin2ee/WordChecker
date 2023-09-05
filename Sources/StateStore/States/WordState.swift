//
//  WordState.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Domain
import Foundation

public struct WordState: State {

    public var wordList: [Word] = []

    var shuffledWordList: CircularLinkedList<Word> = .init()

    public var currentWord: Word?

}
