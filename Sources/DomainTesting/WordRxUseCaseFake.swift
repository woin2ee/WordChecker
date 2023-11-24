//
//  WordRxUseCaseFake.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/12.
//  Copyright © 2023 woin2ee. All rights reserved.
//

@testable import Domain
import Foundation
import RxSwift

public final class WordRxUseCaseFake: WordRxUseCaseProtocol {

    let wordUseCaseFake: WordUseCaseFake = .init()

    public init() {
    }

    public func addNewWord(_ word: Domain.Word) -> RxSwift.Single<Void> {
        wordUseCaseFake.addNewWord(word)
        return .just(())
    }

    public func deleteWord(by uuid: UUID) -> RxSwift.Single<Void> {
        wordUseCaseFake.deleteWord(by: uuid)
        return .just(())
    }

    public func getWordList() -> RxSwift.Single<[Domain.Word]> {
        let wordList = wordUseCaseFake.getWordList()
        return .just(wordList)
    }

    public func getMemorizedWordList() -> RxSwift.Single<[Domain.Word]> {
        let wordList = wordUseCaseFake.getMemorizedWordList()
        return .just(wordList)
    }

    public func getUnmemorizedWordList() -> RxSwift.Single<[Domain.Word]> {
        let wordList = wordUseCaseFake.getUnmemorizedWordList()
        return .just(wordList)
    }

    public func getWord(by uuid: UUID) -> RxSwift.Single<Domain.Word> {
        guard let word = wordUseCaseFake.getWord(by: uuid) else {
            return .error(WordRxUseCaseError.invalidUUID(uuid))
        }
        return .just(word)
    }

    public func updateWord(by uuid: UUID, to newWord: Domain.Word) -> RxSwift.Single<Void> {
        wordUseCaseFake.updateWord(by: uuid, to: newWord)
        return .just(())
    }

    public func randomizeUnmemorizedWordList() -> RxSwift.Single<Void> {
        wordUseCaseFake.randomizeUnmemorizedWordList()
        return .just(())
    }

    public func updateToNextWord() -> RxSwift.Single<Void> {
        wordUseCaseFake.updateToNextWord()
        return .just(())
    }

    public func updateToPreviousWord() -> RxSwift.Single<Void> {
        wordUseCaseFake.updateToPreviousWord()
        return .just(())
    }

    public func markCurrentWordAsMemorized(uuid: UUID) -> RxSwift.Single<Void> {
        wordUseCaseFake.markCurrentWordAsMemorized(uuid: uuid)
        return .just(())
    }

    public func getCurrentUnmemorizedWord() -> Domain.Word? {
        return wordUseCaseFake.getCurrentUnmemorizedWord()
    }

}
