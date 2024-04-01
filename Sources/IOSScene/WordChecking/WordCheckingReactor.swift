//
//  WordCheckingReactor.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/07.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain_UserSettings
import Domain_Word
import Foundation
import IOSSupport
import ReactorKit
import UseCase_Word
import UseCase_UserSettings

enum WordCheckingReactorError: Error {

    enum AddWordFailureReason {
        case duplicatedWord
        case unknown
    }

    case addWordFailed(reason: AddWordFailureReason?, word: String)

}

final class WordCheckingReactor: Reactor {

    enum Action {
        case viewDidLoad
        case addWord(String)
        case updateToNextWord
        case updateToPreviousWord
        case shuffleWordList
        case deleteCurrentWord
        case markCurrentWordAsMemorized
    }

    enum Mutation {
        case setCurrentWord(Word?)
        case setSourceLanguage(TranslationLanguage)
        case setTargetLanguage(TranslationLanguage)
        case showAddCompleteToast(Result<String, WordCheckingReactorError>)
    }

    struct State {
        var currentWord: Word?
        var translationSourceLanguage: TranslationLanguage
        var translationTargetLanguage: TranslationLanguage
        @Pulse var showAddCompleteToast: Result<String, WordCheckingReactorError>?
    }

    let initialState: State = State(
        currentWord: nil,
        translationSourceLanguage: .english,
        translationTargetLanguage: .korean
    )

    let wordUseCase: WordUseCaseProtocol
    let userSettingsUseCase: UserSettingsUseCaseProtocol
    let globalAction: GlobalAction

    init(
        wordUseCase: WordUseCaseProtocol,
        userSettingsUseCase: UserSettingsUseCaseProtocol,
        globalAction: GlobalAction
    ) {
        self.wordUseCase = wordUseCase
        self.userSettingsUseCase = userSettingsUseCase
        self.globalAction = globalAction
    }

    // swiftlint:disable:next cyclomatic_complexity
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            wordUseCase.shuffleUnmemorizedWordList()
            let currentWord = wordUseCase.getCurrentUnmemorizedWord()
            let initCurrrentWord: Mutation = .setCurrentWord(currentWord)

            let initTranslationSourceLanguage = userSettingsUseCase.getCurrentTranslationLocale()
                .map(\.source)
                .map { Mutation.setSourceLanguage($0) }
                .asObservable()
            let initTranslationTargetLanguage = userSettingsUseCase.getCurrentTranslationLocale()
                .map(\.target)
                .map { Mutation.setTargetLanguage($0) }
                .asObservable()

            return .merge([
                .just(initCurrrentWord),
                initTranslationSourceLanguage,
                initTranslationTargetLanguage,
            ])

        case .addWord(let newWord):
            return wordUseCase.addNewWord(newWord)
                .asObservable()
                .flatMap { _ -> Observable<Mutation> in
                    let currentUnmemorizedWord = self.wordUseCase.getCurrentUnmemorizedWord()
                    return .merge([
                        .just(.setCurrentWord(currentUnmemorizedWord)),
                        .just(.showAddCompleteToast(.success(newWord))),
                    ])
                }
                .catch { _ in
                    return .just(.showAddCompleteToast(.failure(.addWordFailed(reason: nil, word: newWord))))
                }

        case .updateToNextWord:
            wordUseCase.updateToNextWord()
            let currentWord = wordUseCase.getCurrentUnmemorizedWord()
            return .just(Mutation.setCurrentWord(currentWord))

        case .updateToPreviousWord:
            wordUseCase.updateToPreviousWord()
            let currentWord = wordUseCase.getCurrentUnmemorizedWord()
            return .just(Mutation.setCurrentWord(currentWord))

        case .shuffleWordList:
            wordUseCase.shuffleUnmemorizedWordList()
            let currentWord = wordUseCase.getCurrentUnmemorizedWord()
            return .just(Mutation.setCurrentWord(currentWord))

        case .deleteCurrentWord:
            guard let uuid = currentState.currentWord?.uuid else {
                return .empty()
            }

            return wordUseCase.deleteWord(by: uuid)
                .asObservable()
                .map { _ -> Mutation in
                    let currentWord = self.wordUseCase.getCurrentUnmemorizedWord()
                    return .setCurrentWord(currentWord)
                }

        case .markCurrentWordAsMemorized:
            guard let uuid = currentState.currentWord?.uuid else {
                return .empty()
            }

            return wordUseCase.markCurrentWordAsMemorized(uuid: uuid)
                .asObservable()
                .map { _ -> Mutation in
                    let currentWord = self.wordUseCase.getCurrentUnmemorizedWord()
                    return .setCurrentWord(currentWord)
                }
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
                    return Mutation.setCurrentWord(currentWord)
                },
            globalAction.didDeleteWord
                .filter { $0.uuid == self.currentState.currentWord?.uuid }
                .map { _ in
                    let currentWord = self.wordUseCase.getCurrentUnmemorizedWord()
                    return Mutation.setCurrentWord(currentWord)
                },
            globalAction.didResetWordList
                .map {
                    let currentWord = self.wordUseCase.getCurrentUnmemorizedWord()
                    return Mutation.setCurrentWord(currentWord)
                },
            globalAction.didAddWord
                .map {
                    let currentWord = self.wordUseCase.getCurrentUnmemorizedWord()
                    return Mutation.setCurrentWord(currentWord)
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
        }

        return state
    }

}
