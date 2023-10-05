//
//  GoogleDriveUseCaseTests.swift
//  DomainUnitTests
//
//  Created by Jaewon Yun on 2023/09/22.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import RxBlocking
import Testing
import XCTest

final class GoogleDriveUseCaseTests: XCTestCase {

    var sut: ExternalStoreUseCaseProtocol!

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        sut = nil
    }

    func test_firstUploadBeforeSignIn() throws {
        // Given
        let wordRepository: WordRepositoryFake = .init(sampleData: testSampleWordList)

        let googleDriveRepository: GoogleDriveRepositoryFake = .init()

        sut = GoogleDriveUseCase.init(
            wordRepository: wordRepository,
            googleDriveRepository: googleDriveRepository,
            unmemorizedWordListState: UnmemorizedWordListStateSpy()
        )

        let presentingConfig: PresentingConfiguration = .init(window: UIViewController())

        // When
        let elements = try sut.upload(presenting: presentingConfig)
            .toBlocking()
            .toArray()

        // Then
        XCTAssertEqual(elements, [.inProgress, .complete])
        XCTAssertEqual(testSampleWordList, googleDriveRepository._wordList)
    }

    func test_uploadAfterSignInWithOutGrant() throws {
        // Given
        let wordRepository: WordRepositoryFake = .init(sampleData: testSampleWordList)

        let googleDriveRepository: GoogleDriveRepositoryFake = .init()
        googleDriveRepository._hasSignIn = true

        sut = GoogleDriveUseCase.init(
            wordRepository: wordRepository,
            googleDriveRepository: googleDriveRepository,
            unmemorizedWordListState: UnmemorizedWordListStateSpy()
        )

        let presentingConfig: PresentingConfiguration = .init(window: UIViewController())

        // When
        let elements = try sut.upload(presenting: presentingConfig)
            .toBlocking()
            .toArray()

        // Then
        XCTAssertEqual(elements, [.inProgress, .complete])
        XCTAssertEqual(testSampleWordList, googleDriveRepository._wordList)
    }

    func test_downloadBeforeSignIn() throws {
        // Given
        let driveData: [Word] = testSampleWordList + [.init(word: "Drive")]

        let wordRepository: WordRepositoryFake = .init(sampleData: testSampleWordList)

        let googleDriveRepository: GoogleDriveRepositoryFake = .init(sampleWordList: driveData)

        let unmemorizedWordListState: UnmemorizedWordListStateSpy = .init()

        sut = GoogleDriveUseCase.init(
            wordRepository: wordRepository,
            googleDriveRepository: googleDriveRepository,
            unmemorizedWordListState: unmemorizedWordListState
        )

        let presentingConfig: PresentingConfiguration = .init(window: UIViewController())

        // When
        let elements = try sut.download(presenting: presentingConfig)
            .toBlocking()
            .toArray()

        // Then
        XCTAssertEqual(elements, [.inProgress, .complete])
        XCTAssertEqual(wordRepository._wordList, driveData)
        XCTAssertEqual(Set(unmemorizedWordListState._storedWords), Set(driveData).filter({ $0.isMemorized == false }))
    }

    func test_downloadWhenNeedSyncToDriveAfterSignIn() throws {
        // Given
        let driveData: [Word] = testSampleWordList + [.init(word: "Drive")]

        let wordRepository: WordRepositoryFake = .init(sampleData: testSampleWordList)

        let googleDriveRepository: GoogleDriveRepositoryFake = .init(sampleWordList: driveData)
        googleDriveRepository._hasSignIn = true
        googleDriveRepository._isGrantedAppDataScope = true

        let unmemorizedWordListState: UnmemorizedWordListStateSpy = .init()

        sut = GoogleDriveUseCase.init(
            wordRepository: wordRepository,
            googleDriveRepository: googleDriveRepository,
            unmemorizedWordListState: unmemorizedWordListState
        )

        // When
        let elements = try sut.download(presenting: nil)
            .toBlocking()
            .toArray()

        // Then
        XCTAssertEqual(elements, [.inProgress, .complete])
        XCTAssertEqual(wordRepository._wordList, driveData)
        XCTAssertEqual(Set(unmemorizedWordListState._storedWords), Set(driveData).filter({ $0.isMemorized == false }))
    }

}

private let testSampleWordList: [Word] = [
    .init(word: "A"),
    .init(word: "B"),
    .init(word: "C"),
    .init(word: "D"),
    .init(word: "E", isMemorized: true),
    .init(word: "F", isMemorized: true),
    .init(word: "G", isMemorized: true),
]
