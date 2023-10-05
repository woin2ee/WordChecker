//
//  UserSettingsViewModelTests.swift
//  DomainUnitTests
//
//  Created by Jaewon Yun on 2023/10/03.
//  Copyright © 2023 woin2ee. All rights reserved.
//

@testable import iOSCore
import RxBlocking
import RxCocoa
import RxTest
import Testing
import XCTest

final class UserSettingsViewModelTests: RxBaseTestCase {

    var sut: UserSettingsViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = .init(
            userSettingsUseCase: UserSettingsUseCaseFake.init(),
            externalStoreUseCase: GoogleDriveUseCaseFake.init()
        )
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        sut = nil
    }

    func testUpload() throws {
        // Given
        let input = makeInput(uploadTrigger: .just(()))
        let output = sut.transform(input: input)

        // When
        let elements = try output.uploadStatus
            .toBlocking()
            .toArray()

        // Then
        XCTAssertEqual(elements, [.inProgress, .complete])
    }

    func testDownload() throws {
        // Given
        let input = makeInput(downloadTrigger: .just(()))
        let output = sut.transform(input: input)

        // When
        let elements = try output.downloadStatus
            .toBlocking()
            .toArray()

        // Then
        XCTAssertEqual(elements, [.inProgress, .complete])
    }

    func testSignOut() throws {
        // Given
        let input = makeInput(signOut: .just(()))
        let output = sut.transform(input: input)

        // When & Then
        try output.signOut
            .toBlocking()
            .single()
    }

    func test_beSignedAfterUpload() throws {
        // Given
        let trigger = testScheduler.createTrigger(emitAt: 300)
        let input = makeInput(uploadTrigger: trigger.asSignalOnErrorJustComplete())
        let output = sut.transform(input: input)

        output.uploadStatus
            .emit()
            .disposed(by: disposeBag)

        // When
        let result = testScheduler.start {
            return output.hasSigned
        }

        // Then
        XCTAssert(result.events.contains { $0.time == TestScheduler.Defaults.subscribed && $0.value == .next(false) })
        XCTAssert(result.events.contains { $0.time == 300 && $0.value == .next(true) })
    }

    func test_beSignedAfterDownload() throws {
        // Given
        let trigger = testScheduler.createTrigger(emitAt: 300)
        let input = makeInput(downloadTrigger: trigger.asSignalOnErrorJustComplete())
        let output = sut.transform(input: input)

        output.downloadStatus
            .emit()
            .disposed(by: disposeBag)

        // When
        let result = testScheduler.start {
            return output.hasSigned
        }

        // Then
        XCTAssert(result.events.contains { $0.time == TestScheduler.Defaults.subscribed && $0.value == .next(false) })
        XCTAssert(result.events.contains { $0.time == 300 && $0.value == .next(true) })
    }

}

// MARK: - Helpers

extension UserSettingsViewModelTests {

    func makeInput(
        uploadTrigger: Signal<Void> = .never(),
        downloadTrigger: Signal<Void> = .never(),
        signOut: Signal<Void> = .never()
    ) -> UserSettingsViewModel.Input {
        return .init(
            uploadTrigger: uploadTrigger,
            downloadTrigger: downloadTrigger,
            signOut: signOut,
            presentingConfiguration: .just(.init(window: UIViewController()))
        )
    }

}
