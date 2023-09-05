//
//  WordUseCaseProtocol.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Foundation

public protocol WordUseCaseProtocol {

    func addNewWord(_ word: Word)

    func deleteWord(_ word: Word)

    func getWordList() -> [Word]

    func editWord(_ word: Word)

    func shuffleUnmemorizedWordList()

}
