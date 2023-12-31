//
//  WordRxUseCaseProtocol.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/11.
//

import Foundation
import RxSwift

public protocol WordRxUseCaseProtocol {

    func addNewWord(_ word: Word) -> Single<Void>

    func deleteWord(by uuid: UUID) -> Single<Void>

    func getWordList() -> Single<[Word]>

    func getMemorizedWordList() -> Single<[Word]>

    func getUnmemorizedWordList() -> Single<[Word]>

    func getWord(by uuid: UUID) -> Single<Word>

    func updateWord(by uuid: UUID, to newWord: Word) -> Single<Void>

    func randomizeUnmemorizedWordList() -> Single<Void>

    func updateToNextWord() -> Single<Void>

    func updateToPreviousWord() -> Single<Void>

    func markCurrentWordAsMemorized(uuid: UUID) -> Single<Void>

    func getCurrentUnmemorizedWord() -> Word?

}
