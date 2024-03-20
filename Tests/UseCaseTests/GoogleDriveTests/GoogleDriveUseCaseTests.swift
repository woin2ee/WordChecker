//
//  GoogleDriveUseCaseTests.swift
//  DomainUnitTests
//
//  Created by Jaewon Yun on 2023/09/22.
//  Copyright © 2023 woin2ee. All rights reserved.
//

@testable import Domain_ExternalStorage
import Domain_ExternalStorageInterface
import Domain_ExternalStorageTesting

import Domain_NotificationTesting
import Domain_WordInterface
import Domain_WordTesting

@testable import Utility

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

        let googleDriveService: GoogleDriveServiceFake = .init()

        sut = ExternalStoreUseCase.init(
            wordRepository: wordRepository,
            unmemorizedWordListRepository: UnmemorizedWordListRepositorySpy(),
            googleDriveService: googleDriveService,
            notificationsUseCase: notificationsUseCase
        )

        let presentingConfig: PresentingConfiguration = .init(window: UIViewController())

        // When
        let elements = try sut.upload(presenting: presentingConfig)
            .toBlocking()
            .toArray()

        // Then
        XCTAssertEqual(elements, [.inProgress, .complete])
        XCTAssertEqual(testSampleWordList, googleDriveService._wordList)
    }

    func test_uploadAfterSignInWithOutGrant() throws {
        // Given
        let wordRepository: WordRepositoryFake = .init(sampleData: testSampleWordList)

        let googleDriveService: GoogleDriveServiceFake = .init()
        googleDriveService._hasSignIn = true

        sut = ExternalStoreUseCase.init(
            wordRepository: wordRepository,
            unmemorizedWordListRepository: UnmemorizedWordListRepositorySpy(),
            googleDriveService: googleDriveService,
            notificationsUseCase: notificationsUseCase
        )

        let presentingConfig: PresentingConfiguration = .init(window: UIViewController())

        // When
        let elements = try sut.upload(presenting: presentingConfig)
            .toBlocking()
            .toArray()

        // Then
        XCTAssertEqual(elements, [.inProgress, .complete])
        XCTAssertEqual(testSampleWordList, googleDriveService._wordList)
    }

    func test_downloadBeforeSignIn() throws {
        // Given
        let driveData: [Word] = testSampleWordList + [try! .init(word: "Drive")]

        let wordRepository: WordRepositoryFake = .init(sampleData: testSampleWordList)

        let googleDriveService: GoogleDriveServiceFake = .init(sampleWordList: driveData)

        let unmemorizedWordListRepository: UnmemorizedWordListRepositorySpy = .init()

        sut = ExternalStoreUseCase.init(
            wordRepository: wordRepository,
            unmemorizedWordListRepository: unmemorizedWordListRepository,
            googleDriveService: googleDriveService,
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
        let driveData: [Word] = testSampleWordList + [try! .init(word: "Drive")]

        let wordRepository: WordRepositoryFake = .init(sampleData: testSampleWordList)

        let googleDriveService: GoogleDriveServiceFake = .init(sampleWordList: driveData)
        googleDriveService._hasSignIn = true
        googleDriveService._isGrantedAppDataScope = true

        let unmemorizedWordListRepository: UnmemorizedWordListRepositorySpy = .init()

        sut = ExternalStoreUseCase.init(
            wordRepository: wordRepository,
            unmemorizedWordListRepository: unmemorizedWordListRepository,
            googleDriveService: googleDriveService,
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
    try! .init(word: "A"),
    try! .init(word: "B"),
    try! .init(word: "C"),
    try! .init(word: "D"),
    try! .init(word: "E", memorizedState: .memorized),
    try! .init(word: "F", memorizedState: .memorized),
    try! .init(word: "G", memorizedState: .memorized),
]
