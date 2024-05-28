//
//  DefaultWordUseCase.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/11.
//

import Domain_LocalNotification
import Domain_WordManagement
import Domain_WordMemorization
import Foundation
import FoundationPlus
import RxSwift

internal final class DefaultWordUseCase: WordUseCase {

    private let wordManagementService: WordManagementService
    private let wordMemorizationService: WordMemorizationService
    private let localNotificationService: LocalNotificationService

    init(wordManagementService: WordManagementService, wordMemorizationService: WordMemorizationService, localNotificationService: LocalNotificationService) {
        self.wordManagementService = wordManagementService
        self.wordMemorizationService = wordMemorizationService
        self.localNotificationService = localNotificationService
    }

    func addNewWord(_ word: String) -> RxSwift.Single<Void> {
        return .create { observer in
            do {
                let uuid = UUID()
                // Todo: Needs a transaction?
                try self.wordManagementService.addNewWord(word, with: uuid)
                try self.wordMemorizationService.appendWord(word, with: uuid)
                observer(.success(()))
                self.updateDailyReminder()
            } catch {
                observer(.failure(error))
            }

            return Disposables.create()
        }
    }

    func deleteWord(by uuid: UUID) -> RxSwift.Single<Void> {
        return .create { observer in
            do {
                try self.wordManagementService.deleteWord(by: uuid)
                self.wordMemorizationService.deleteWord(by: uuid)
                observer(.success(()))
                self.updateDailyReminder()
            } catch {
                observer(.failure(error))
            }
            return Disposables.create()
        }
    }

    func fetchWordList() -> [Domain_WordManagement.Word] {
        return wordManagementService.fetchWordList()
    }

    func fetchMemorizedWordList() -> [Domain_WordManagement.Word] {
        return wordManagementService.fetchMemorizedWordList()
    }

    func fetchMemorizingWordList() -> [Domain_WordManagement.Word] {
        return wordManagementService.fetchUnmemorizedWordList()
    }

    func fetchWord(by uuid: UUID) -> RxSwift.Single<Domain_WordManagement.Word> {
        guard let word = wordManagementService.fetchWord(by: uuid) else {
            return .error(WordUseCaseError.uuidInvalid)
        }
        return .just(word)
    }

    func updateWord(by uuid: UUID, with newAttribute: WordAttribute) -> RxSwift.Single<Void> {
        let hasUpdateWord: Bool = newAttribute.word != nil
        let hasUpdateMemorizationState: Bool = newAttribute.memorizationState != nil
        
        return .create { observer in
            do {
                try self.wordManagementService.updateWord(with: newAttribute, id: uuid)
                
                if !hasUpdateWord, hasUpdateMemorizationState {
                    switch newAttribute.memorizationState! {
                    case .memorized:
                        self.wordMemorizationService.deleteWord(by: uuid)
                    case .memorizing:
                        guard let word = self.wordManagementService.fetchWord(by: uuid) else {
                            throw WordUseCaseError.uuidInvalid
                        }
                        try self.wordMemorizationService.insertWord(word.word, with: uuid)
                    }
                }
                else if hasUpdateWord, !hasUpdateMemorizationState {
                    self.wordMemorizationService.updateWord(to: newAttribute.word!, with: uuid)
                }
                else if hasUpdateWord, hasUpdateMemorizationState {
                    switch newAttribute.memorizationState! {
                    case .memorized:
                        self.wordMemorizationService.deleteWord(by: uuid)
                    case .memorizing:
                        try self.wordMemorizationService.insertWord(newAttribute.word!, with: uuid)
                    }
                }
                
                self.updateDailyReminder()
                observer(.success(()))
            } catch {
                observer(.failure(error))
            }
            return Disposables.create()
        }
    }

    func shuffleUnmemorizedWordList() {
        wordMemorizationService.shuffleList()
    }

    func updateToNextWord() -> Domain_WordMemorization.MemorizingWord? {
        return wordMemorizationService.next()
    }

    func updateToPreviousWord() -> Domain_WordMemorization.MemorizingWord? {
        return wordMemorizationService.previous()
    }

    func markCurrentWordAsMemorized() -> RxSwift.Single<Void> {
        guard let currentID = self.wordMemorizationService.current?.id else {
            return .just(())
        }
        
        return .create { observer in
            do {
                try self.wordManagementService.markWordsAsMemorized(by: [currentID])
                self.wordMemorizationService.deleteCurrent()
                observer(.success(()))
                self.updateDailyReminder()
            } catch {
                observer(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    func markWordsAsMemorized(by uuids: [UUID]) -> Single<Void> {
        return .create { observer in
            do {
                try self.wordManagementService.markWordsAsMemorized(by: uuids)
                uuids.forEach { uuid in
                    self.wordMemorizationService.deleteWord(by: uuid)
                }
                observer(.success(()))
                self.updateDailyReminder()
            } catch {
                observer(.failure(error))
            }
            return Disposables.create()
        }
    }

    func getCurrentUnmemorizedWord() -> Domain_WordMemorization.MemorizingWord? {
        return wordMemorizationService.current
    }

    func isWordDuplicated(_ word: String) -> RxSwift.Single<Bool> {
        do {
            let isDuplicated = try wordManagementService.isWordDuplicated(word)
            return .just(isDuplicated)
        } catch {
            return .error(error)
        }
    }
    
    func getCheckedCount() -> Int {
        wordMemorizationService.checkedCount
    }
    
    func initializeMemorizingList() {
        let list = wordManagementService.fetchUnmemorizedWordList().compactMap { word in
            do {
                return try MemorizingWord(id: word.uuid, word: word.word, isChecked: false)
            } catch {
                logger.error("\(error.localizedDescription)")
                return nil
            }
        }
        wordMemorizationService.setList(list)
    }
}

// MARK: Helpers

extension DefaultWordUseCase {

    private func updateDailyReminder() {
        Task {
            guard let dailyReminder = await self.localNotificationService.getPendingDailyReminder() else {
                logger.notice("There is no pending daily reminder.")
                return
            }

            let newDailyReminder = DailyReminder(
                unmemorizedWordCount: self.wordMemorizationService.count,
                noticeTime: dailyReminder.noticeTime
            )
            try await self.localNotificationService.setDailyReminder(newDailyReminder)
        } catch: { error in
            logger.error("\(error.localizedDescription)")
        }
    }
}
