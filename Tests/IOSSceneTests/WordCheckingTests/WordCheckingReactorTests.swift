//
//  WordCheckingReactorTests.swift
//  DomainUnitTests
//
//  Created by Jaewon Yun on 11/22/23.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain_LocalNotificationTesting
import Domain_WordManagementTesting
@testable import Domain_WordMemorization
import Domain_WordMemorizationTesting
@testable import IOSScene_WordChecking
import IOSSupport
@testable import UseCase_Word
@testable import UseCase_WordTesting
import UseCase_UserSettingsTesting

import XCTest

final class WordCheckingReactorTests: XCTestCase {

    var sut: WordCheckingReactor!

    override func setUpWithError() throws {
        sut = WordCheckingReactor(
            wordUseCase: DefaultWordUseCase(
                wordManagementService: FakeWordManagementService(),
                wordMemorizationService: FakeWordMemorizationService(),
                localNotificationService: LocalNotificationServiceFake()
            ),
            userSettingsUseCase: UserSettingsUseCaseFake(),
            globalAction: GlobalAction.shared,
            globalState: GlobalState.shared
        )
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_firstAddWord() {
        // When
        sut.action.onNext(.addWord("Test"))

        // Then
        XCTAssertEqual(sut.currentState.currentWord?.word, "Test")
    }
    
    func test_addWord_withAutoCapitalization() {
        // Given
        sut.globalState.autoCapitalizationIsOn = true
        
        // When
        sut.action.onNext(.addWord("test"))
        
        // Then
        XCTAssertEqual(sut.currentState.currentWord?.word, "Test")
    }

    func test_deleteLastWord() {
        // Given
        sut.action.onNext(.addWord("Test"))

        // When
        sut.action.onNext(.deleteCurrentWord)

        // Then
        XCTAssertNil(sut.currentState.currentWord)
    }

    func test_markAsMemorizedLastWord() {
        // Given
        sut.action.onNext(.addWord("Test"))

        // When
        sut.action.onNext(.markCurrentWordAsMemorized)

        // Then
        XCTAssertNil(sut.currentState.currentWord)
    }

    func test_addDuplicatedWord() {
        // Given
        sut.action.onNext(.addWord("testWord"))

        // When
        sut.action.onNext(.addWord("TESTWORD"))

        // Then
        XCTAssertNotNil(sut.currentState.showAddCompleteToast)
    }

    func test_initialFontSize() {
        // Given
        let wordUseCase = DefaultWordUseCase(
            wordManagementService: FakeWordManagementService(),
            wordMemorizationService: FakeWordMemorizationService(),
            localNotificationService: LocalNotificationServiceFake()
        )
        let userSettingsUseCase = UserSettingsUseCaseFake()
        userSettingsUseCase.currentUserSettings.memorizingWordSize = .veryLarge
        sut = .init(
            wordUseCase: wordUseCase,
            userSettingsUseCase: userSettingsUseCase,
            globalAction: .shared,
            globalState: GlobalState.shared
        )
        
        // When
        sut.action.onNext(.viewDidLoad)
        
        // Then
        XCTAssertEqual(sut.currentState.fontSize, .veryLarge)
    }
    
    func test_currentIndex_whenEmptyList() {
        sut.action.onNext(.viewDidLoad)
        XCTAssertEqual(sut.currentState.currentIndex, nil)
    }
    
    func test_currentIndex_whileMemorizing() {
        // Given
        sut.action.onNext(.addWord("A"))
        sut.action.onNext(.addWord("B"))
        sut.action.onNext(.addWord("C"))
        sut.action.onNext(.viewDidLoad)
        XCTAssertEqual(sut.currentState.currentIndex, 0)
        
        // When
        sut.action.onNext(.updateToNextWord)
        sut.action.onNext(.updateToNextWord)
        sut.action.onNext(.updateToPreviousWord)
        
        // Then
        XCTAssertEqual(sut.currentState.currentIndex, 1)
    }
    
    func test_memorizingCount_whenViewDidLoad() {
        // Given
        sut.action.onNext(.addWord("A"))
        sut.action.onNext(.addWord("B"))
        sut.action.onNext(.addWord("C"))
        
        // When
        sut.action.onNext(.viewDidLoad)
        
        // Then
        XCTAssertEqual(sut.currentState.memorizingCount.checked, 0)
        XCTAssertEqual(sut.currentState.memorizingCount.total, 3)
    }
    
    func test_memorizingCount_whenUpdateToNextWord() {
        // Given
        sut.action.onNext(.addWord("A"))
        sut.action.onNext(.addWord("B"))
        sut.action.onNext(.addWord("C"))
        sut.action.onNext(.viewDidLoad)
        
        // When
        sut.action.onNext(.updateToNextWord)
        
        // Then
        XCTAssertEqual(sut.currentState.memorizingCount.checked, 1)
        XCTAssertEqual(sut.currentState.memorizingCount.total, 3)
    }
    
    func test_memorizingCount_whenUpdateToPreviousWord() {
        // Given
        sut.action.onNext(.addWord("A"))
        sut.action.onNext(.addWord("B"))
        sut.action.onNext(.addWord("C"))
        sut.action.onNext(.viewDidLoad)
        sut.action.onNext(.updateToNextWord)
        sut.action.onNext(.updateToNextWord)
        
        // When
        sut.action.onNext(.updateToPreviousWord)
        
        // Then
        XCTAssertEqual(sut.currentState.memorizingCount.checked, 2)
        XCTAssertEqual(sut.currentState.memorizingCount.total, 3)
    }
    
    func test_memorizingCount_whenBackAndForth() {
        // Given
        sut.action.onNext(.addWord("A"))
        sut.action.onNext(.addWord("B"))
        sut.action.onNext(.addWord("C"))
        sut.action.onNext(.addWord("D"))
        sut.action.onNext(.viewDidLoad)
        
        // When
        sut.action.onNext(.updateToPreviousWord)
        sut.action.onNext(.updateToNextWord)
        sut.action.onNext(.updateToNextWord)
        sut.action.onNext(.updateToPreviousWord)
        sut.action.onNext(.updateToNextWord)
        sut.action.onNext(.updateToNextWord)
        
        // Then
        XCTAssertEqual(sut.currentState.memorizingCount.checked, 3)
        XCTAssertEqual(sut.currentState.memorizingCount.total, 4)
    }
    
    func test_memorizingCount_whenShuffleWordList() {
        // Given
        sut.action.onNext(.addWord("A"))
        sut.action.onNext(.addWord("B"))
        sut.action.onNext(.addWord("C"))
        sut.action.onNext(.viewDidLoad)
        sut.action.onNext(.updateToNextWord)
        sut.action.onNext(.updateToNextWord)
        let currentWord = sut.currentState.currentWord?.word
        
        // When
        sut.action.onNext(.shuffleWordList)
        
        // Then
        XCTAssertEqual(sut.currentState.memorizingCount.checked, 0)
        XCTAssertEqual(sut.currentState.memorizingCount.total, 3)
        XCTAssertNotEqual(currentWord, sut.currentState.currentWord?.word)
    }
    
    func test_memorizingCount_whenWordIsAdded() {
        // Given
        sut.action.onNext(.addWord("A"))
        sut.action.onNext(.addWord("B"))
        sut.action.onNext(.addWord("C"))
        sut.action.onNext(.viewDidLoad)
        
        // When
        sut.action.onNext(.addWord("D"))
        
        // Then
        XCTAssertEqual(sut.currentState.memorizingCount.checked, 0)
        XCTAssertEqual(sut.currentState.memorizingCount.total, 4)
    }
    
    func test_memorizingCount_whenDuplicatedWordIsAdded() {
        // Given
        sut.action.onNext(.addWord("A"))
        sut.action.onNext(.addWord("B"))
        sut.action.onNext(.addWord("C"))
        sut.action.onNext(.viewDidLoad)
        
        // When
        sut.action.onNext(.addWord("A"))
        
        // Then
        XCTAssertEqual(sut.currentState.memorizingCount.checked, 0)
        XCTAssertEqual(sut.currentState.memorizingCount.total, 3)
    }
    
    func test_memorizingCount_whenWordIsAdded_whileMemorizing() {
        // Given
        sut.action.onNext(.addWord("A"))
        sut.action.onNext(.addWord("B"))
        sut.action.onNext(.addWord("C"))
        sut.action.onNext(.viewDidLoad)
        sut.action.onNext(.updateToNextWord)
        sut.action.onNext(.updateToNextWord)
        
        // When
        sut.action.onNext(.addWord("D"))
        
        // Then
        XCTAssertEqual(sut.currentState.memorizingCount.checked, 2)
        XCTAssertEqual(sut.currentState.memorizingCount.total, 4)
        XCTAssertEqual(sut.currentState.currentIndex, 2)
    }
    
    func test_memorizingCount_whenWordIsMemorized() {
        // Given
        sut.action.onNext(.addWord("A"))
        sut.action.onNext(.addWord("B"))
        sut.action.onNext(.addWord("C"))
        sut.action.onNext(.viewDidLoad)
        sut.action.onNext(.updateToNextWord)
        
        // When
        sut.action.onNext(.markCurrentWordAsMemorized)
        
        // Then
        XCTAssertEqual(sut.currentState.memorizingCount.checked, 1)
        XCTAssertEqual(sut.currentState.memorizingCount.total, 2)
    }
    
    func test_memorizingCount_whenWordIsMemorized_withEmptyList() {
        // Given
        sut.action.onNext(.viewDidLoad)
        
        // When
        sut.action.onNext(.markCurrentWordAsMemorized)
        
        // Then
        XCTAssertEqual(sut.currentState.memorizingCount.checked, 0)
        XCTAssertEqual(sut.currentState.memorizingCount.total, 0)
    }
    
    func test_memorizingCount_whenWordIsMemorized_withAllChecked() {
        // Given
        sut.action.onNext(.addWord("A"))
        sut.action.onNext(.addWord("B"))
        sut.action.onNext(.addWord("C"))
        sut.action.onNext(.viewDidLoad)
        sut.action.onNext(.updateToNextWord)
        sut.action.onNext(.updateToNextWord)
        sut.action.onNext(.updateToNextWord)
        
        // When
        sut.action.onNext(.markCurrentWordAsMemorized)
        
        // Then
        XCTAssertEqual(sut.currentState.memorizingCount.checked, 2)
        XCTAssertEqual(sut.currentState.memorizingCount.total, 2)
    }

    func test_memorizingCount_whenWordIsDeleted() {
        // Given
        sut.action.onNext(.addWord("A"))
        sut.action.onNext(.addWord("B"))
        sut.action.onNext(.addWord("C"))
        sut.action.onNext(.viewDidLoad)
        sut.action.onNext(.updateToNextWord)
        
        // When
        sut.action.onNext(.deleteCurrentWord)
        
        // Then
        XCTAssertEqual(sut.currentState.memorizingCount.checked, 1)
        XCTAssertEqual(sut.currentState.memorizingCount.total, 2)
    }
    
    func test_memorizingCount_whenWordIsDeleted_withEmptyList() {
        // Given
        sut.action.onNext(.viewDidLoad)
        
        // When
        sut.action.onNext(.deleteCurrentWord)
        
        // Then
        XCTAssertEqual(sut.currentState.memorizingCount.checked, 0)
        XCTAssertEqual(sut.currentState.memorizingCount.total, 0)
    }
    
    func test_memorizingCount_whenWordIsDeleted_withAllChecked() {
        // Given
        sut.action.onNext(.addWord("A"))
        sut.action.onNext(.addWord("B"))
        sut.action.onNext(.addWord("C"))
        sut.action.onNext(.viewDidLoad)
        sut.action.onNext(.updateToNextWord)
        sut.action.onNext(.updateToNextWord)
        sut.action.onNext(.updateToNextWord)
        
        // When
        sut.action.onNext(.deleteCurrentWord)
        
        // Then
        XCTAssertEqual(sut.currentState.memorizingCount.checked, 2)
        XCTAssertEqual(sut.currentState.memorizingCount.total, 2)
    }
}
