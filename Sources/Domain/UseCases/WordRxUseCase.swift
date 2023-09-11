//
//  WordRxUseCase.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/11.
//

import Foundation
import RxSwift
import Utility

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

    public func deleteWord(_ word: Word) -> RxSwift.Single<Void> {
        return .create { single in
            self.wordUseCase.deleteWord(word)

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

    public func getWord(with uuid: UUID) -> RxSwift.Single<Word> {
        return .create { single in
            let maybeWord = self.wordUseCase.getWord(with: uuid)

            do {
                let word = try unwrapOrThrow(maybeWord)
                single(.success(word))
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }

    public func updateWord(with uuid: UUID, to newWord: Word) -> RxSwift.Single<Void> {
        return .create { single in
            self.wordUseCase.updateWord(with: uuid, to: newWord)

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

}
