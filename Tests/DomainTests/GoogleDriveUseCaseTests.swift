//
//  GoogleDriveUseCaseTests.swift
//  DomainUnitTests
//
//  Created by Jaewon Yun on 2023/09/22.
//  Copyright © 2023 woin2ee. All rights reserved.
//

@testable import Domain
@testable import Utility

import DataDriverTesting
import DomainTesting
import RxBlocking
import XCTest

final class GoogleDriveUseCaseTests: XCTestCase {

    var sut: ExternalStoreUseCaseProtocol!

    let notificationsUseCase = NotificationsUseCaseMock(expectedAuthorizationStatus: .authorized)

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
            unmemorizedWordListRepository: UnmemorizedWordListRepositorySpy(),
            notificationsUseCase: notificationsUseCase
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
            unmemorizedWordListRepository: UnmemorizedWordListRepositorySpy(),
            notificationsUseCase: notificationsUseCase
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

        let unmemorizedWordListRepository: UnmemorizedWordListRepositorySpy = .init()

        sut = GoogleDriveUseCase.init(
            wordRepository: wordRepository,
            googleDriveRepository: googleDriveRepository,
            unmemorizedWordListRepository: unmemorizedWordListRepository,
            notificationsUseCase: notificationsUseCase
        )

        let presentingConfig: PresentingConfiguration = .init(window: UIViewController())

        // When
        let elements = try sut.download(presenting: presentingConfig)
            .toBlocking()
            .toArray()

        // Then
        XCTAssertEqual(elements, [.inProgress, .complete])
        XCTAssertEqual(wordRepository._wordList, driveData)
        XCTAssertEqual(Set(unmemorizedWordListRepository._storedWords.elements), Set(driveData).filter({ $0.memorizedState == .memorizing }))
        XCTAssertEqual(notificationsUseCase.updateDailyReminderCallCount, 1)
    }

    func test_downloadWhenNeedSyncToDriveAfterSignIn() throws {
        // Given
        let driveData: [Word] = testSampleWordList + [.init(word: "Drive")]

        let wordRepository: WordRepositoryFake = .init(sampleData: testSampleWordList)

        let googleDriveRepository: GoogleDriveRepositoryFake = .init(sampleWordList: driveData)
        googleDriveRepository._hasSignIn = true
        googleDriveRepository._isGrantedAppDataScope = true

        let unmemorizedWordListRepository: UnmemorizedWordListRepositorySpy = .init()

        sut = GoogleDriveUseCase.init(
            wordRepository: wordRepository,
            googleDriveRepository: googleDriveRepository,
            unmemorizedWordListRepository: unmemorizedWordListRepository,
            notificationsUseCase: notificationsUseCase
        )

        // When
        let elements = try sut.download(presenting: nil)
            .toBlocking()
            .toArray()

        // Then
        XCTAssertEqual(elements, [.inProgress, .complete])
        XCTAssertEqual(wordRepository._wordList, driveData)
        XCTAssertEqual(Set(unmemorizedWordListRepository._storedWords.elements), Set(driveData).filter({ $0.memorizedState == .memorizing }))
        XCTAssertEqual(notificationsUseCase.updateDailyReminderCallCount, 1)
    }

}

private let testSampleWordList: [Word] = [
    .init(word: "A"),
    .init(word: "B"),
    .init(word: "C"),
    .init(word: "D"),
    .init(word: "E", memorizedState: .memorized),
    .init(word: "F", memorizedState: .memorized),
    .init(word: "G", memorizedState: .memorized),
]
