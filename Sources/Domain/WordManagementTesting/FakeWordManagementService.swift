//
//  FakeWordManagementService.swift
//  IOSScene_WordChecking
//
//  Created by Jaewon Yun on 5/28/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

@testable import Domain_WordManagement
import Foundation

public final class FakeWordManagementService: WordManagementService {
    
    private let _wordManagementService: WordManagementService
    
    public init() {
        let wordRepository: WordRepository = FakeWordRepository()
        self._wordManagementService = DefaultWordManagementService(
            wordRepository: wordRepository,
            wordDuplicateSpecification: WordDuplicateSpecification(wordRepository: wordRepository)
        )
    }
    
    public func addNewWord(_ word: String, with id: UUID) throws {
        try _wordManagementService.addNewWord(word, with: id)
    }
    
    public func deleteWord(by uuid: UUID) throws {
        try _wordManagementService.deleteWord(by: uuid)
    }

    public func fetchWordList() -> [Domain_WordManagement.Word] {
        return _wordManagementService.fetchWordList()
    }

    public func fetchUnmemorizedWordList() -> [Domain_WordManagement.Word] {
        return _wordManagementService.fetchUnmemorizedWordList()
    }

    public func fetchMemorizedWordList() -> [Domain_WordManagement.Word] {
        return _wordManagementService.fetchMemorizedWordList()
    }

    public func fetchWord(by uuid: UUID) -> Domain_WordManagement.Word? {
        return _wordManagementService.fetchWord(by: uuid)
    }

    public func updateWord(with newAttribute: Domain_WordManagement.WordAttribute, id: UUID) throws {
        try _wordManagementService.updateWord(with: newAttribute, id: id)
    }

    public func markWordsAsMemorized(by uuids: [UUID]) throws {
        try _wordManagementService.markWordsAsMemorized(by: uuids)
    }

    public func isWordDuplicated(_ word: String) throws -> Bool {
        return try _wordManagementService.isWordDuplicated(word)
    }

    public func reset(to newWordList: [Domain_WordManagement.Word]) throws {
        try _wordManagementService.reset(to: newWordList)
    }

}
