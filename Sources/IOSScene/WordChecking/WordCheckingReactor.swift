import Domain_UserSettings
import Foundation
import IOSSupport
import ReactorKit
import UseCase_Word
import UseCase_UserSettings

final class WordCheckingReactor: Reactor {

    typealias FontSize = MemorizingWordSize
    
    enum Action {
        case viewDidLoad
        case addWord(String)
        case updateToNextWord
        case updateToPreviousWord
        case shuffleWordList
        case deleteCurrentWord
        case markCurrentWordAsMemorized
        case changeFontSize(FontSize)
    }

    enum Mutation {
        case setCurrentWord(Word?)
        case setSourceLanguage(TranslationLanguage)
        case setTargetLanguage(TranslationLanguage)
        case showAddCompleteToast(Result<String, WordCheckingReactorError>)
        case setFontSize(FontSize)
        case setCheckedWordsCount(Int)
        case resetCheckedWordsCount
        case setMemorizingWordsCount(Int)
    }

    struct State {
        var currentWord: Word?
        var fontSize: FontSize
        var translationSourceLanguage: TranslationLanguage
        var translationTargetLanguage: TranslationLanguage
        var memorizingCount: MemorizingCount
        @Pulse var showAddCompleteToast: Result<String, WordCheckingReactorError>?
    }

    let initialState: State = State(
        currentWord: nil,
        fontSize: .default,
        translationSourceLanguage: .english,
        translationTargetLanguage: .korean,
        memorizingCount: MemorizingCount(checked: 0, total: 0)
    )

    let wordUseCase: WordUseCase
    let userSettingsUseCase: UserSettingsUseCase
    let globalAction: GlobalAction
    let globalState: GlobalState

    init(
        wordUseCase: WordUseCase,
        userSettingsUseCase: UserSettingsUseCase,
        globalAction: GlobalAction,
        globalState: GlobalState
    ) {
        self.wordUseCase = wordUseCase
        self.userSettingsUseCase = userSettingsUseCase
        self.globalAction = globalAction
        self.globalState = globalState
    }

    // swiftlint:disable:next cyclomatic_complexity
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            wordUseCase.initializeMemorizingList()
            
            let currentWord = wordUseCase.getCurrentUnmemorizedWord()
            let initCurrrentWord: Mutation = .setCurrentWord(currentWord?.toDTO())

            let initTranslationSourceLanguage = userSettingsUseCase.getCurrentTranslationLocale()
                .map(\.source)
                .map { Mutation.setSourceLanguage($0) }
                .asObservable()
            let initTranslationTargetLanguage = userSettingsUseCase.getCurrentTranslationLocale()
                .map(\.target)
                .map { Mutation.setTargetLanguage($0) }
                .asObservable()
            let currentFontSize = userSettingsUseCase.getCurrentUserSettings()
                .map(\.memorizingWordSize)
                .map { Mutation.setFontSize($0) }
                .asObservable()

            return .merge([
                .just(initCurrrentWord),
                initTranslationSourceLanguage,
                initTranslationTargetLanguage,
                currentFontSize,
                .just(.setMemorizingWordsCount(wordUseCase.fetchMemorizingWordList().count))
            ])

        case .addWord(let newWord):
            var newWord = newWord
            
            if globalState.autoCapitalizationIsOn {
                newWord = newWord.prefix(1).uppercased() + newWord.dropFirst()
            }
            
            return wordUseCase.addNewWord(newWord)
                .asObservable()
                .flatMap { _ -> Observable<Mutation> in
                    let currentUnmemorizedWord = self.wordUseCase.getCurrentUnmemorizedWord()
                    return .merge([
                        .just(.setCurrentWord(currentUnmemorizedWord?.toDTO())),
                        .just(.showAddCompleteToast(.success(newWord))),
                    ])
                }
                .catch { _ in
                    return .just(.showAddCompleteToast(.failure(.addWordFailed(reason: nil, word: newWord))))
                }

        case .updateToNextWord:
            wordUseCase.updateToNextWord()
            let currentWord = wordUseCase.getCurrentUnmemorizedWord()
            return .merge([
                .just(Mutation.setCurrentWord(currentWord?.toDTO())),
                .just(.setCheckedWordsCount(wordUseCase.getCheckedCount())),
            ])

        case .updateToPreviousWord:
            wordUseCase.updateToPreviousWord()
            let currentWord = wordUseCase.getCurrentUnmemorizedWord()
            return .just(Mutation.setCurrentWord(currentWord?.toDTO()))

        case .shuffleWordList:
            wordUseCase.shuffleUnmemorizedWordList()
            let currentWord = wordUseCase.getCurrentUnmemorizedWord()
            return .merge([
                .just(.setCurrentWord(currentWord?.toDTO())),
                .just(.setCheckedWordsCount(0))
            ])

        case .deleteCurrentWord:
            guard let id = currentState.currentWord?.id else {
                return .empty()
            }

            return wordUseCase.deleteWord(by: id)
                .asObservable()
                .map { _ -> Mutation in
                    let currentWord = self.wordUseCase.getCurrentUnmemorizedWord()
                    return .setCurrentWord(currentWord?.toDTO())
                }

        case .markCurrentWordAsMemorized:
            return wordUseCase.markCurrentWordAsMemorized()
                .asObservable()
                .map { _ -> Mutation in
                    let currentWord = self.wordUseCase.getCurrentUnmemorizedWord()
                    return .setCurrentWord(currentWord?.toDTO())
                }
            
        case .changeFontSize(let fontSize):
            return userSettingsUseCase.changeMemorizingWordSize(fontSize: fontSize)
                .asObservable()
                .map { Mutation.setFontSize(fontSize) }
        }
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        return .merge([
            mutation,
            globalAction.didSetSourceLanguage
                .map(Mutation.setSourceLanguage),
            globalAction.didSetTargetLanguage
                .map(Mutation.setTargetLanguage),
            globalAction.didEditWord
                .map { _ in
                    let currentWord = self.wordUseCase.getCurrentUnmemorizedWord()
                    return Mutation.setCurrentWord(currentWord?.toDTO())
                },
            globalAction.didDeleteWords
                .filter { $0.contains(where: { $0.uuid == self.currentState.currentWord?.id }) }
                .map { _ in
                    let currentWord = self.wordUseCase.getCurrentUnmemorizedWord()
                    return Mutation.setCurrentWord(currentWord?.toDTO())
                },
            globalAction.didResetWordList
                .map {
                    let currentWord = self.wordUseCase.getCurrentUnmemorizedWord()
                    return Mutation.setCurrentWord(currentWord?.toDTO())
                },
            globalAction.didAddWord
                .map {
                    let currentWord = self.wordUseCase.getCurrentUnmemorizedWord()
                    return Mutation.setCurrentWord(currentWord?.toDTO())
                },
            globalAction.didMarkSomeWordsAsMemorized
                .map {
                    let currentWord = self.wordUseCase.getCurrentUnmemorizedWord()
                    return Mutation.setCurrentWord(currentWord?.toDTO())
                },
        ])
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case .setCurrentWord(let currentWord):
            state.currentWord = currentWord
        case .setSourceLanguage(let translationSourceLanguage):
            state.translationSourceLanguage = translationSourceLanguage
        case .setTargetLanguage(let translationTargetLanguage):
            state.translationTargetLanguage = translationTargetLanguage
        case .showAddCompleteToast(let result):
            state.showAddCompleteToast = result
        case .setFontSize(let fontSize):
            state.fontSize = fontSize
        case .setCheckedWordsCount(let count):
            state.memorizingCount.checked = count
        case .resetCheckedWordsCount:
            state.memorizingCount.checked = 0
        case .setMemorizingWordsCount(let count):
            state.memorizingCount.total = count
        }

        return state
    }

}
