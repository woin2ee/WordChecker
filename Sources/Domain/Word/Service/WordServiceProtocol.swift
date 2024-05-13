//
//  WordServiceProtocol.swift
//  Domain_WordTesting
//
//  Created by Jaewon Yun on 3/28/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Foundation

public protocol WordService {
    func addNewWord(_ word: String) throws
    func deleteWord(by uuid: UUID) throws
    func fetchWordList() -> [Word]
    func fetchUnmemorizedWordList() -> [Word]
    func fetchMemorizedWordList() -> [Word]
    func fetchWord(by uuid: UUID) -> Word?
    func updateWord(with newAttribute: WordAttribute, id: UUID) throws
    func shuffleUnmemorizedWordList()
    func updateToNextWord()
    func updateToPreviousWord()
    func markCurrentWordAsMemorized() throws
    func markWordsAsMemorized(by uuids: [UUID]) throws
    func getCurrentUnmemorizedWord() -> Word?
    func isWordDuplicated(_ word: String) throws -> Bool
    func reset(to newWordList: [Word]) throws
}
