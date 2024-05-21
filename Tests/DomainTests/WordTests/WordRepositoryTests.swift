//
//  Created by Jaewon Yun on 2/19/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

@testable import Domain_Word

import Realm
import RealmSwift
import XCTest

final class WordRepositoryTests: XCTestCase {

    var sut: RealmWordRepository!
    
    override func setUpWithError() throws {
        let config: Realm.Configuration = .init(inMemoryIdentifier: String(describing: self))
        let realm: Realm = try .init(configuration: config)
        sut = .init(realm: realm)
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_ignoreCaseSensitive_whenGetByWord() throws {
        // Given
        let word1: Word = try .init(word: "TEST")
        let word2: Word = try .init(word: "test")
        try sut.save(word1)
        try sut.save(word2)
        
        // When
        let results = sut.getWords(by: "TeST")
        
        // Then
        XCTAssertEqual(results.count, 2)
    }
    
    func test_saveSamePrimaryKeyItem() throws {
        // Given
        var testWord: Word = try .init(word: "TestWord", memorizationState: .memorizing)
        try sut.save(testWord)
        
        testWord.memorizationState = .memorized
        
        // When
        try sut.save(testWord)
        
        // Then
        XCTAssertEqual(sut.getWord(by: testWord.uuid), testWord)
    }
}
