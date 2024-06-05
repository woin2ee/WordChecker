import Domain_GoogleDrive
@testable import Domain_GoogleDriveTesting
import Domain_WordManagement
import Domain_WordManagementTesting
import Domain_WordMemorization
import Domain_WordMemorizationTesting
@testable import IOSScene_UserSettings
@testable import IOSScene_WordAddition
@testable import IOSScene_WordChecking
@testable import IOSScene_WordDetail
@testable import IOSScene_WordList
import IOSSupport
import RxBlocking
import RxSwift
import RxTest
import RxSwiftSugar
import TestsSupport
import UseCase_GoogleDriveTesting
import UseCase_UserSettingsTesting
import UseCase_Word
import UseCase_WordTesting
import XCTest

final class WordCheckingReactorIntegrationTests: RxBaseTestCase {
    
    func test_memorizingCount_whenReceivingDidAddWordGlobalAction() {
        // Given
        let wordUseCase = FakeWordUseCase()
        let wordCheckingReactor = WordCheckingReactor(
            wordUseCase: wordUseCase,
            userSettingsUseCase: UserSettingsUseCaseFake(),
            globalAction: GlobalAction.shared,
            globalState: GlobalState.shared
        )
        wordCheckingReactor.action.onNext(.viewDidLoad)
        let wordAdditionViewModel = WordAdditionViewModel(
            wordUseCase: wordUseCase,
            globalState: GlobalState.shared,
            globalAction: GlobalAction.shared
        )
        let trigger = testScheduler.createTrigger()
        let wordAdditionViewModelInput = WordAdditionViewModel.Input(
            wordText: .just("Test"),
            saveAttempt: trigger.asSignalOnErrorJustComplete(),
            dismissAttempt: .never()
        )
        let wordAdditionViewModelOutput = wordAdditionViewModel.transform(input: wordAdditionViewModelInput)
        
        // When
        let result = testScheduler.start {
            wordAdditionViewModelOutput.saveComplete
        }
        
        // Then
        XCTAssertRecordedElements(result.events, [()])
        XCTAssertEqual(wordCheckingReactor.currentState.currentWord?.word, "Test")
        XCTAssertEqual(wordCheckingReactor.currentState.currentIndex, 0)
        XCTAssertEqual(wordCheckingReactor.currentState.memorizingCount.checked, 0)
        XCTAssertEqual(wordCheckingReactor.currentState.memorizingCount.total, 1)
    }
    
    func test_memorizingCount_whenReceivingDidDeleteWordsGlobalAction_whileMemorizing() {
        // Given
        let wordUseCase = FakeWordUseCase()
        let wordCheckingReactor = WordCheckingReactor(
            wordUseCase: wordUseCase,
            userSettingsUseCase: UserSettingsUseCaseFake(),
            globalAction: GlobalAction.shared,
            globalState: GlobalState.shared
        )
        wordCheckingReactor.action.onNext(.viewDidLoad)
        wordCheckingReactor.action.onNext(.addWord("A"))
        wordCheckingReactor.action.onNext(.addWord("B"))
        wordCheckingReactor.action.onNext(.addWord("C"))
        wordCheckingReactor.action.onNext(.updateToNextWord)
        let wordListReactor = WordListReactor(
            globalAction: GlobalAction.shared,
            wordUseCase: wordUseCase
        )
        wordListReactor.action.onNext(.viewDidLoad)
        wordListReactor.action.onNext(.refreshWordListByCurrentType)
        
        // When
        let index = wordListReactor.currentState.wordList.firstIndex(where: { $0.word == "B" })!
        wordListReactor.action.onNext(.deleteWord(index))
        
        // Then
        XCTAssertEqual(wordCheckingReactor.currentState.currentWord?.word, "C")
        XCTAssertEqual(wordCheckingReactor.currentState.currentIndex, 1)
        XCTAssertEqual(wordCheckingReactor.currentState.memorizingCount.checked, 1)
        XCTAssertEqual(wordCheckingReactor.currentState.memorizingCount.total, 2)
    }
    
    func test_memorizingCount_whenReceivingDidResetWordListGlobalAction() throws {
        // Given
        let wordManagementService = FakeWordManagementService()
        let wordMemorizationService = FakeWordMemorizationService.fake()
        
        let wordUseCase = FakeWordUseCase(
            wordManagementService: wordManagementService,
            wordMemorizationService: wordMemorizationService
        )
        
        let wordCheckingReactor = WordCheckingReactor(
            wordUseCase: wordUseCase,
            userSettingsUseCase: UserSettingsUseCaseFake(),
            globalAction: GlobalAction.shared,
            globalState: GlobalState.shared
        )
        wordCheckingReactor.action.onNext(.viewDidLoad)
        wordCheckingReactor.action.onNext(.addWord("A"))
        wordCheckingReactor.action.onNext(.addWord("B"))
        wordCheckingReactor.action.onNext(.addWord("C"))
        wordCheckingReactor.action.onNext(.updateToNextWord)
        
        let googleDriveService = GoogleDriveServiceFake()
        let word = try Word(word: "Test")
        let data = try JSONEncoder().encode([word])
        googleDriveService.backupFiles = [BackupFile(name: .wordListBackup, data: data)]
        
        let googleDriveUseCase = GoogleDriveUseCaseFake(
            googleDriveService: googleDriveService,
            wordService: wordManagementService,
            wordMemorizationService: wordMemorizationService
        )
        
        let userSettingsReactor = UserSettingsReactor(
            userSettingsUseCase: UserSettingsUseCaseFake(),
            googleDriveUseCase: googleDriveUseCase,
            globalAction: GlobalAction.shared
        )
        userSettingsReactor.action.onNext(.viewDidLoad)
        
        // When
        userSettingsReactor.action.onNext(.downloadData(PresentingConfiguration(window: UIViewController())))
        
        // Then
        XCTAssertEqual(wordCheckingReactor.currentState.currentWord?.word, "Test")
        XCTAssertEqual(wordCheckingReactor.currentState.currentIndex, 0)
        XCTAssertEqual(wordCheckingReactor.currentState.memorizingCount.checked, 0)
        XCTAssertEqual(wordCheckingReactor.currentState.memorizingCount.total, 1)
    }
    
    func test_memorizingCount_whenReceivingDidEditWordGlobalAction_whileMemorizing() {
        // Given
        let wordUseCase = FakeWordUseCase()
        let wordCheckingReactor = WordCheckingReactor(
            wordUseCase: wordUseCase,
            userSettingsUseCase: UserSettingsUseCaseFake(),
            globalAction: GlobalAction.shared,
            globalState: GlobalState.shared
        )
        wordCheckingReactor.action.onNext(.viewDidLoad)
        wordCheckingReactor.action.onNext(.addWord("A"))
        wordCheckingReactor.action.onNext(.addWord("B"))
        wordCheckingReactor.action.onNext(.addWord("C"))
        wordCheckingReactor.action.onNext(.updateToNextWord)
        let uuidB = wordUseCase.fetchWordList().first(where: { $0.word == "B" })!.uuid
        let wordDetailReactor = WordDetailReactor(
            uuid: uuidB,
            globalAction: GlobalAction.shared,
            wordUseCase: wordUseCase
        )
        wordDetailReactor.action.onNext(.viewDidLoad)
        
        // When
        wordDetailReactor.action.onNext(.changeMemorizationState(.memorized))
        wordDetailReactor.action.onNext(.doneEditing)
        
        // Then
        XCTAssertEqual(wordCheckingReactor.currentState.currentWord?.word, "C")
        XCTAssertEqual(wordCheckingReactor.currentState.currentIndex, 1)
        XCTAssertEqual(wordCheckingReactor.currentState.memorizingCount.checked, 1)
        XCTAssertEqual(wordCheckingReactor.currentState.memorizingCount.total, 2)
    }
    
    func test_memorizingCount_whenReceivingDidMarkSomeWordsAsMemorizedGlobalAction_whileMemorizing() {
        // Given
        let wordUseCase = FakeWordUseCase()
        let wordCheckingReactor = WordCheckingReactor(
            wordUseCase: wordUseCase,
            userSettingsUseCase: UserSettingsUseCaseFake(),
            globalAction: GlobalAction.shared,
            globalState: GlobalState.shared
        )
        wordCheckingReactor.action.onNext(.viewDidLoad)
        wordCheckingReactor.action.onNext(.addWord("A"))
        wordCheckingReactor.action.onNext(.addWord("B"))
        wordCheckingReactor.action.onNext(.addWord("C"))
        wordCheckingReactor.action.onNext(.updateToNextWord)
        let wordListReactor = WordListReactor(
            globalAction: GlobalAction.shared,
            wordUseCase: wordUseCase
        )
        wordListReactor.action.onNext(.viewDidLoad)
        wordListReactor.action.onNext(.refreshWordListByCurrentType)
        
        // When
        let indexB = wordListReactor.currentState.wordList.firstIndex(where: { $0.word == "B" })!
        let indexC = wordListReactor.currentState.wordList.firstIndex(where: { $0.word == "C" })!
        wordListReactor.action.onNext(.markWordsAsMemorized([
            IndexPath(row: indexB, section: 0),
            IndexPath(row: indexC, section: 0),
        ]))
        
        // Then
        XCTAssertEqual(wordCheckingReactor.currentState.currentWord?.word, "A")
        XCTAssertEqual(wordCheckingReactor.currentState.currentIndex, 0)
        XCTAssertEqual(wordCheckingReactor.currentState.memorizingCount.checked, 1)
        XCTAssertEqual(wordCheckingReactor.currentState.memorizingCount.total, 1)
    }
}
