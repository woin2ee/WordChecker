//
//  WordUseCaseProtocol.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Foundation

public protocol WordUseCaseProtocol {

    func addNewWord(_ word: Word)

    func deleteWord(by uuid: UUID)

    func getWordList() -> [Word]

    func getMemorizedWordList() -> [Word]

    func getUnmemorizedWordList() -> [Word]

    func getWord(by uuid: UUID) -> Word?

    func updateWord(by uuid: UUID, to newWord: Word)

    func randomizeUnmemorizedWordList()

    func updateToNextWord()

    func updateToPreviousWord()

    func markCurrentWordAsMemorized(uuid: UUID)

    var currentUnmemorizedWord: Word? { get }

}
