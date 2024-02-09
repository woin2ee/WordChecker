//
//  WordCheckingReactor.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/07.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation
import iOSSupport
import ReactorKit

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
    }

    struct State {
        var currentWord: Word?
        var translationSourceLanguage: TranslationLanguage
        var translationTargetLanguage: TranslationLanguage
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

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let initUnmemorizedWordList = wordUseCase.shuffleUnmemorizedWordList()
                .flatMap { self.wordUseCase.getCurrentUnmemorizedWord() }
                .map(Mutation.setCurrentWord)
                .catchAndReturn(.setCurrentWord(nil))
                .asObservable()
            let initTranslationSourceLanguage = userSettingsUseCase.getCurrentTranslationLocale()
                .map(\.source)
                .map { Mutation.setSourceLanguage($0) }
                .asObservable()
            let initTranslationTargetLanguage = userSettingsUseCase.getCurrentTranslationLocale()
                .map(\.target)
                .map { Mutation.setTargetLanguage($0) }
                .asObservable()

            return .merge([
                initUnmemorizedWordList,
                initTranslationSourceLanguage,
                initTranslationTargetLanguage,
            ])

        case .addWord(let newWord):
            let newWord: Word = .init(word: newWord)
            return wordUseCase.addNewWord(newWord)
                .asObservable()
                .flatMap { self.wordUseCase.getCurrentUnmemorizedWord() }
                .map(Mutation.setCurrentWord)
                .catchAndReturn(.setCurrentWord(nil))

        case .updateToNextWord:
            return wordUseCase.updateToNextWord()
                .asObservable()
                .flatMap { self.wordUseCase.getCurrentUnmemorizedWord() }
                .map(Mutation.setCurrentWord)
                .catchAndReturn(.setCurrentWord(nil))

        case .updateToPreviousWord:
            return wordUseCase.updateToPreviousWord()
                .asObservable()
                .flatMap { self.wordUseCase.getCurrentUnmemorizedWord() }
                .map(Mutation.setCurrentWord)
                .catchAndReturn(.setCurrentWord(nil))

        case .shuffleWordList:
            return wordUseCase.shuffleUnmemorizedWordList()
                .asObservable()
                .flatMap { self.wordUseCase.getCurrentUnmemorizedWord() }
                .map(Mutation.setCurrentWord)
                .catchAndReturn(.setCurrentWord(nil))

        case .deleteCurrentWord:
            guard let uuid = currentState.currentWord?.uuid else {
                return .empty()
            }

            return wordUseCase.deleteWord(by: uuid)
                .asObservable()
                .flatMap { self.wordUseCase.getCurrentUnmemorizedWord() }
                .map(Mutation.setCurrentWord)
                .catchAndReturn(.setCurrentWord(nil))

        case .markCurrentWordAsMemorized:
            guard let uuid = currentState.currentWord?.uuid else {
                return .empty()
            }

            return wordUseCase.markCurrentWordAsMemorized(uuid: uuid)
                .asObservable()
                .flatMap { self.wordUseCase.getCurrentUnmemorizedWord() }
                .map(Mutation.setCurrentWord)
                .catchAndReturn(.setCurrentWord(nil))
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
                .flatMap { _ in return self.wordUseCase.getCurrentUnmemorizedWord() }
                .map(Mutation.setCurrentWord)
                .catchAndReturn(.setCurrentWord(nil)),
            globalAction.didDeleteWord
                .filter { $0.uuid == self.currentState.currentWord?.uuid }
                .flatMap { _ in return self.wordUseCase.getCurrentUnmemorizedWord() }
                .map(Mutation.setCurrentWord)
                .catchAndReturn(.setCurrentWord(nil)),
            globalAction.didResetWordList
                .flatMap { self.wordUseCase.getCurrentUnmemorizedWord() }
                .map(Mutation.setCurrentWord)
                .catchAndReturn(.setCurrentWord(nil)),
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
        }

        return state
    }

}
