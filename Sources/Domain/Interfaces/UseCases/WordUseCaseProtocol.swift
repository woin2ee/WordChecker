//
//  WordUseCaseProtocol.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Combine
import Foundation

public protocol WordUseCaseProtocol {

    func addNewWord(_ word: Word)

    func deleteWord(_ word: Word)

    func getWordList() -> [Word]

    func getWord(with uuid: UUID) -> Word?

    func updateWord(with uuid: UUID, to newWord: Word)

    func randomizeUnmemorizedWordList()

    func updateToNextWord()

    func updateToPreviousWord()

}
