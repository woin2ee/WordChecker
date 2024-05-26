//
//  DefaultWordUseCase.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/11.
//

import Domain_LocalNotification
import Domain_WordManagement
import Foundation
import RxSwift

internal final class DefaultWordUseCase: WordUseCase {

    private let wordService: WordService
    private let localNotificationService: LocalNotificationService

    init(wordService: WordService, localNotificationService: LocalNotificationService) {
        self.wordService = wordService
        self.localNotificationService = localNotificationService
    }

    func addNewWord(_ word: String) -> RxSwift.Single<Void> {
        return .create { observer in
            do {
                try self.wordService.addNewWord(word)
                observer(.success(()))
                self.updateDailyReminder()
            } catch {
                observer(.failure(error))
            }

            return Disposables.create()
        }
    }

    func deleteWord(by uuid: UUID) -> RxSwift.Single<Void> {
        do {
            try wordService.deleteWord(by: uuid)
            updateDailyReminder()
            return .just(())
        } catch {
            return .error(error)
        }
    }

    func fetchWordList() -> [Word] {
        return wordService.fetchWordList()
    }

    func fetchMemorizedWordList() -> [Word] {
        return wordService.fetchMemorizedWordList()
    }

    func fetchUnmemorizedWordList() -> [Word] {
        return wordService.fetchUnmemorizedWordList()
    }

    func fetchWord(by uuid: UUID) -> RxSwift.Single<Word> {
        guard let word = wordService.fetchWord(by: uuid) else {
            return .error(WordUseCaseError.uuidInvalid)
        }
        return .just(word)
    }

    func updateWord(by uuid: UUID, with newAttribute: WordAttribute) -> RxSwift.Single<Void> {
        do {
            try wordService.updateWord(with: newAttribute, id: uuid)
            updateDailyReminder()
            return .just(())
        } catch {
            return .error(error)
        }
    }

    func shuffleUnmemorizedWordList() {
        wordService.shuffleUnmemorizedWordList()
    }

    func updateToNextWord() {
        wordService.updateToNextWord()
    }

    func updateToPreviousWord() {
        wordService.updateToPreviousWord()
    }

    func markCurrentWordAsMemorized() -> RxSwift.Single<Void> {
        do {
            try wordService.markCurrentWordAsMemorized()
            updateDailyReminder()
            return .just(())
        } catch {
            return .error(error)
        }
    }
    
    func markWordsAsMemorized(by uuids: [UUID]) -> Single<Void> {
        return .create { observer in
            do {
                try self.wordService.markWordsAsMemorized(by: uuids)
                self.updateDailyReminder()
                observer(.success(()))
            } catch {
                observer(.failure(error))
            }
            return Disposables.create()
        }
    }

    func getCurrentUnmemorizedWord() -> Word? {
        return wordService.getCurrentUnmemorizedWord()
    }

    func isWordDuplicated(_ word: String) -> RxSwift.Single<Bool> {
        do {
            let isDuplicated = try wordService.isWordDuplicated(word)
            return .just(isDuplicated)
        } catch {
            return .error(error)
        }
    }
}

// MARK: Helpers

extension DefaultWordUseCase {

    private func updateDailyReminder() {
        let unmemorizedWordCount = wordService.fetchUnmemorizedWordList().count

        Task {
            guard let dailyReminder = await self.localNotificationService.getPendingDailyReminder() else {
                return
            }

            let newDailyReminder = DailyReminder(
                unmemorizedWordCount: unmemorizedWordCount,
                noticeTime: dailyReminder.noticeTime
            )
            try await self.localNotificationService.setDailyReminder(newDailyReminder)
        }
    }
}
