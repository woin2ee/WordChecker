//
//  DefaultGoogleDriveUseCaseTests.swift
//  DomainUnitTests
//
//  Created by Jaewon Yun on 2023/09/22.
//  Copyright © 2023 woin2ee. All rights reserved.
//

@testable import UseCase_GoogleDrive
@testable import Domain_GoogleDrive
@testable import Domain_GoogleDriveTesting
@testable import Domain_LocalNotification
@testable import Domain_LocalNotificationTesting
@testable import Domain_WordManagement
@testable import Domain_WordManagementTesting
@testable import Domain_WordMemorization
@testable import Domain_WordMemorizationTesting

import RxBlocking
import XCTest

final class DefaultGoogleDriveUseCaseTests: XCTestCase {

    var sut: DefaultGoogleDriveUseCase!

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        sut = nil
    }

    func test_ifUploadSuccess_withoutSignIn() throws {
        // Given
        let googleDriveServiceFake = GoogleDriveServiceFake()
        
        sut = .init(
            googleDriveService: googleDriveServiceFake,
            wordService: WordServiceStub(), 
            wordMemorizationService: FakeWordMemorizationService.fake(),
            localNotificationService: LocalNotificationServiceDummy()
        )
        
        XCTAssertFalse(sut.hasSigned)

        // When
        let presentingConfig: PresentingConfiguration = .init(window: UIViewController())
        let elements = try sut.upload(presenting: presentingConfig)
            .toBlocking()
            .toArray()

        // Then
        XCTAssertTrue(sut.hasSigned)
        XCTAssertEqual(elements, [.inProgress, .complete])
        XCTAssertEqual(googleDriveServiceFake.backupFiles.count, 1)
    }

    func test_ifUploadSuccess_withScopeUngrantedSignIn() throws {
        // Given
        let googleDriveServiceFake = GoogleDriveServiceFake()
        googleDriveServiceFake.hasSigned = true
        
        sut = .init(
            googleDriveService: googleDriveServiceFake,
            wordService: WordServiceStub(),
            wordMemorizationService: FakeWordMemorizationService.fake(),
            localNotificationService: LocalNotificationServiceDummy()
        )
        
        // When
        let presentingConfig: PresentingConfiguration = .init(window: UIViewController())
        let elements = try sut.upload(presenting: presentingConfig)
            .toBlocking()
            .toArray()

        // Then
        XCTAssertEqual(elements, [.inProgress, .complete])
        XCTAssertEqual(googleDriveServiceFake.backupFiles.count, 1)
    }

    func test_downloadBackupFile_whenNeedToSync_withSignIn() async throws {
        // Given
        let wordList: [Word] = [
            try! Word(word: "Apple"),
            try! Word(word: "Banana"),
        ]
        let wordListData = try JSONEncoder().encode(wordList)
        
        let googleDriveServiceFake = GoogleDriveServiceFake()
        googleDriveServiceFake.hasSigned = true
        googleDriveServiceFake.isGrantedAppDataScope = true
        googleDriveServiceFake.backupFiles = [BackupFile(name: .wordListBackup, data: wordListData)]
        
        let wordRepositoryFake = FakeWordRepository()
        let wordServiceFake = DefaultWordManagementService(
            wordRepository: wordRepositoryFake,
            wordDuplicateSpecification: WordDuplicateSpecification(wordRepository: wordRepositoryFake)
        )
        
        let localNotificationServiceFake = LocalNotificationServiceFake()
        let dailyReminder = DailyReminder(unmemorizedWordCount: 0, noticeTime: NoticeTime(hour: 1, minute: 1))
        _ = try await localNotificationServiceFake.requestAuthorization(options: .alert)
        try await localNotificationServiceFake.setDailyReminder(dailyReminder)
        
        sut = .init(
            googleDriveService: googleDriveServiceFake,
            wordService: wordServiceFake,
            wordMemorizationService: FakeWordMemorizationService.fake(),
            localNotificationService: localNotificationServiceFake
        )
        
        // When
        let elements = try sut.download(presenting: nil)
            .toBlocking()
            .toArray()

        // Then
        XCTAssertEqual(elements, [.inProgress, .complete])
        XCTAssertEqual(wordServiceFake.fetchWordList(), wordList)
        XCTAssertEqual(localNotificationServiceFake.pendingDailyReminder?.unmemorizedWordCount, wordList.count)
    }
}
