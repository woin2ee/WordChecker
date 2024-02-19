//
//  WordRepositoryTests.swift
//  InfrastructureTests
//
//  Created by Jaewon Yun on 2/19/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

@testable import Infrastructure

import Domain
import Realm
import RealmSwift
import XCTest

final class WordRepositoryTests: XCTestCase {

    var sut: WordRepository!
    var config: Realm.Configuration!
    
    override func tearDownWithError() throws {
        try FileManager().removeItem(at: config.fileURL!)
        
        sut = nil
        config = nil
    }
    
    func test_ignoreCaseSensitive_whenGetByWord() throws {
        // Given
        config = .init()
        config.fileURL?.deleteLastPathComponent()
        config.fileURL?.append(path: "\(#function)")
        config.fileURL?.appendPathExtension(".realm")
        let realm: Realm = try .init(configuration: config)
        sut = .init(realm: realm)
        
        let word1: Domain.Word = try .init(word: "TEST")
        let word2: Domain.Word = try .init(word: "test")
        sut.save(word1)
        sut.save(word2)
        
        // When
        let results = sut.getWords(by: "TeST")
        
        // Then
        XCTAssertEqual(results.count, 2)
    }
}
