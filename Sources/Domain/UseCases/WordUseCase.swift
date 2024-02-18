//
//  WordUseCase.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/11.
//

import Foundation
import RxSwift

public final class WordUseCase: WordUseCaseProtocol {

    let wordRepository: WordRepositoryProtocol
    let unmemorizedWordListRepository: UnmemorizedWordListRepositoryProtocol
    let notificationsUseCase: NotificationsUseCaseProtocol

    let wordDuplicateSpecification: WordDuplicateSpecification

    init(wordRepository: WordRepositoryProtocol, unmemorizedWordListRepository: UnmemorizedWordListRepositoryProtocol, notificationsUseCase: NotificationsUseCaseProtocol, wordDuplicateSpecification: WordDuplicateSpecification) {
        self.wordRepository = wordRepository
        self.unmemorizedWordListRepository = unmemorizedWordListRepository
        self.notificationsUseCase = notificationsUseCase
        self.wordDuplicateSpecification = wordDuplicateSpecification
    }

    public func addNewWord(_ word: Word) -> RxSwift.Single<Void> {
        guard word.memorizedState != .memorized else {
            return .error(WordUseCaseError.saveFailed(reason: .wordStateInvalid))
        }

        guard self.wordDuplicateSpecification.isSatisfied(for: word) else {
            return .error(WordUseCaseError.saveFailed(reason: .duplicatedWord(word: word.word)))
        }

        self.unmemorizedWordListRepository.addWord(word)
        self.wordRepository.save(word)

        _ = self.notificationsUseCase.updateDailyReminder()
            .subscribe()

        return .just(())
    }

    public func deleteWord(by uuid: UUID) -> RxSwift.Single<Void> {
        return .create { single in
            self.unmemorizedWordListRepository.deleteWord(by: uuid)
            self.wordRepository.deleteWord(by: uuid)

            _ = self.notificationsUseCase.updateDailyReminder()
                .subscribe()

            single(.success(()))

            return Disposables.create()
        }
    }

    public func getWordList() -> RxSwift.Single<[Word]> {
        return .create { single in
            let wordList = self.wordRepository.getAllWords()
            single(.success(wordList))

            return Disposables.create()
        }
    }

    public func getUnmemorizedWordList() -> Single<[Word]> {
        return .create { single in
            let unmemorizedList = self.wordRepository.getUnmemorizedList()
            single(.success(unmemorizedList))

            return Disposables.create()
        }
    }

    public func getMemorizedWordList() -> Single<[Word]> {
        return .create { single in
            let memorizedList = self.wordRepository.getMemorizedList()
            single(.success(memorizedList))

            return Disposables.create()
        }
    }

    public func getWord(by uuid: UUID) -> RxSwift.Single<Word> {
        return .create { single in
            if let word = self.wordRepository.getWord(by: uuid) {
                single(.success(word))
            } else {
                single(.failure(WordUseCaseError.retrieveFailed(reason: .uuidInvaild(uuid: uuid))))
            }

            return Disposables.create()
        }
    }

    public func updateWord(by uuid: UUID, to newWord: Word) -> RxSwift.Single<Void> {
        let updateTarget: Word
        do {
            updateTarget = try .init(
                uuid: uuid,
                word: newWord.word,
                memorizedState: newWord.memorizedState
            )
        } catch {
            return .error(error)
        }

        guard self.wordDuplicateSpecification.isSatisfied(for: updateTarget) else {
            return .error(WordUseCaseError.saveFailed(reason: .duplicatedWord(word: updateTarget.word)))
        }

        if self.unmemorizedWordListRepository.contains(where: { $0.uuid == updateTarget.uuid }) {
            if updateTarget.memorizedState == .memorized {
                self.unmemorizedWordListRepository.deleteWord(by: uuid)
            }
            self.unmemorizedWordListRepository.replaceWord(where: uuid, with: updateTarget)
        } else if updateTarget.memorizedState == .memorizing {
            self.unmemorizedWordListRepository.addWord(updateTarget)
        }

        self.wordRepository.save(updateTarget)

        return .just(())
    }

    public func shuffleUnmemorizedWordList() -> RxSwift.Single<Void> {
        return .create { single in
            let unmemorizedList = self.wordRepository.getUnmemorizedList()
            self.unmemorizedWordListRepository.shuffle(with: unmemorizedList)

            single(.success(()))

            return Disposables.create()
        }
    }

    public func updateToNextWord() -> RxSwift.Single<Void> {
        return .create { single in
            self.unmemorizedWordListRepository.updateToNextWord()

            single(.success(()))

            return Disposables.create()
        }
    }

    public func updateToPreviousWord() -> RxSwift.Single<Void> {
        return .create { single in
            self.unmemorizedWordListRepository.updateToPreviousWord()

            single(.success(()))

            return Disposables.create()
        }
    }

    public func markCurrentWordAsMemorized(uuid: UUID) -> RxSwift.Single<Void> {
        return .create { single in
            guard let currentWord = self.wordRepository.getWord(by: uuid) else {
                single(.failure(WordUseCaseError.retrieveFailed(reason: .uuidInvaild(uuid: uuid))))
                return Disposables.create()
            }

            currentWord.memorizedState = .memorized

            self.unmemorizedWordListRepository.deleteWord(by: uuid)
            self.wordRepository.save(currentWord)

            single(.success(()))

            return Disposables.create()
        }
    }

    public func getCurrentUnmemorizedWord() -> Single<Word> {
        guard let currentWord = unmemorizedWordListRepository.getCurrentWord() else {
            return .error(WordUseCaseError.noMemorizingWords)
        }

        return .just(currentWord)
    }

    public func isWordDuplicated(_ word: String) -> Single<Bool> {
        let tempEntity: Word
        do {
            tempEntity = try .init(word: word)
        } catch {
            return .error(error)
        }

        return wordDuplicateSpecification.isSatisfied(for: tempEntity) ? .just(false) : .just(true)
    }

}
