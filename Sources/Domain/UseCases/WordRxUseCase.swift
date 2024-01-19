//
//  WordRxUseCase.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/11.
//

import Foundation
import RxSwift

public final class WordRxUseCase: WordRxUseCaseProtocol {

    let wordUseCase: WordUseCaseProtocol

    public init(wordUseCase: WordUseCaseProtocol) {
        self.wordUseCase = wordUseCase
    }

    public func addNewWord(_ word: Word) -> RxSwift.Single<Void> {
        return .create { single in
            self.wordUseCase.addNewWord(word)

            single(.success(()))

            return Disposables.create()
        }
    }

    public func deleteWord(by uuid: UUID) -> RxSwift.Single<Void> {
        return .create { single in
            self.wordUseCase.deleteWord(by: uuid)

            single(.success(()))

            return Disposables.create()
        }
    }

    public func getWordList() -> RxSwift.Single<[Word]> {
        return .create { single in
            let wordList = self.wordUseCase.getWordList()

            single(.success(wordList))

            return Disposables.create()
        }
    }

    public func getUnmemorizedWordList() -> Single<[Word]> {
        return .create { single in
            let wordList = self.wordUseCase.getUnmemorizedWordList()

            single(.success(wordList))

            return Disposables.create()
        }
    }

    public func getMemorizedWordList() -> Single<[Word]> {
        return .create { single in
            let wordList = self.wordUseCase.getMemorizedWordList()

            single(.success(wordList))

            return Disposables.create()
        }
    }

    public func getWord(by uuid: UUID) -> RxSwift.Single<Word> {
        return .create { single in
            if let word = self.wordUseCase.getWord(by: uuid) {
                single(.success(word))
            } else {
                single(.failure(WordRxUseCaseError.invalidUUID(uuid)))
            }

            return Disposables.create()
        }
    }

    public func updateWord(by uuid: UUID, to newWord: Word) -> RxSwift.Single<Void> {
        return .create { single in
            self.wordUseCase.updateWord(by: uuid, to: newWord)

            single(.success(()))

            return Disposables.create()
        }
    }

    public func randomizeUnmemorizedWordList() -> RxSwift.Single<Void> {
        return .create { single in
            self.wordUseCase.randomizeUnmemorizedWordList()

            single(.success(()))

            return Disposables.create()
        }
    }

    public func updateToNextWord() -> RxSwift.Single<Void> {
        return .create { single in
            self.wordUseCase.updateToNextWord()

            single(.success(()))

            return Disposables.create()
        }
    }

    public func updateToPreviousWord() -> RxSwift.Single<Void> {
        return .create { single in
            self.wordUseCase.updateToPreviousWord()

            single(.success(()))

            return Disposables.create()
        }
    }

    public func markCurrentWordAsMemorized(uuid: UUID) -> RxSwift.Single<Void> {
        return .create { single in
            self.wordUseCase.markCurrentWordAsMemorized(uuid: uuid)

            single(.success(()))

            return Disposables.create()
        }
    }

    public func getCurrentUnmemorizedWord() -> Word? {
        return wordUseCase.getCurrentUnmemorizedWord()
    }

}

enum WordRxUseCaseError: Error {
    case invalidUUID(UUID)
}
