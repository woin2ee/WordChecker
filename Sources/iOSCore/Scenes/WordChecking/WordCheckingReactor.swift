//
//  WordCheckingReactor.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/07.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation
import ReactorKit

public final class WordCheckingReactor: Reactor {

    public enum Action {
        case viewDidLoad
        case addWord(String)
        case updateToNextWord
        case updateToPreviousWord
        case shuffleWordList
        case deleteCurrentWord
        case markCurrentWordAsMemorized
    }

    public enum Mutation {
        case setCurrentWord(Word?)
        case setSourceLanguage(TranslationLanguage)
        case setTargetLanguage(TranslationLanguage)
    }

    public struct State {
        var currentWord: Word?
        var translationSourceLanguage: TranslationLanguage
        var translationTargetLanguage: TranslationLanguage
    }

    public let initialState: State = State(
        currentWord: nil,
        translationSourceLanguage: .english,
        translationTargetLanguage: .korean
    )

    let wordUseCase: WordRxUseCaseProtocol
    let userSettingsUseCase: UserSettingsUseCaseProtocol
    let globalAction: GlobalAction

    public init(
        wordUseCase: WordRxUseCaseProtocol,
        userSettingsUseCase: UserSettingsUseCaseProtocol,
        globalAction: GlobalAction
    ) {
        self.wordUseCase = wordUseCase
        self.userSettingsUseCase = userSettingsUseCase
        self.globalAction = globalAction
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let initUnmemorizedWordList = wordUseCase.randomizeUnmemorizedWordList()
                .map { Mutation.setCurrentWord(self.wordUseCase.currentUnmemorizedWord) }
                .asObservable()
            let initTranslationSourceLanguage = userSettingsUseCase.currentTranslationLocale
                .map(\.source)
                .map { Mutation.setSourceLanguage($0) }
                .asObservable()
            let initTranslationTargetLanguage = userSettingsUseCase.currentTranslationLocale
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
                .map {
                    return Mutation.setCurrentWord(self.wordUseCase.currentUnmemorizedWord)
                }

        case .updateToNextWord:
            return wordUseCase.updateToNextWord()
                .map {
                    return Mutation.setCurrentWord(self.wordUseCase.currentUnmemorizedWord)
                }
                .asObservable()

        case .updateToPreviousWord:
            return wordUseCase.updateToPreviousWord()
                .map {
                    return Mutation.setCurrentWord(self.wordUseCase.currentUnmemorizedWord)
                }
                .asObservable()

        case .shuffleWordList:
            return wordUseCase.randomizeUnmemorizedWordList()
                .map {
                    return Mutation.setCurrentWord(self.wordUseCase.currentUnmemorizedWord)
                }
                .asObservable()

        case .deleteCurrentWord:
            guard let uuid = currentState.currentWord?.uuid else {
                return .empty()
            }

            return wordUseCase.deleteWord(by: uuid)
                .map {
                    return Mutation.setCurrentWord(self.wordUseCase.currentUnmemorizedWord)
                }
                .asObservable()

        case .markCurrentWordAsMemorized:
            guard let uuid = currentState.currentWord?.uuid else {
                return .empty()
            }

            return wordUseCase.markCurrentWordAsMemorized(uuid: uuid)
                .map {
                    return Mutation.setCurrentWord(self.wordUseCase.currentUnmemorizedWord)
                }
                .asObservable()
        }
    }

    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        return .merge([
            mutation,
            globalAction.didSetSourceLanguage
                .map(Mutation.setSourceLanguage),
            globalAction.didSetTargetLanguage
                .map(Mutation.setTargetLanguage),
            globalAction.didEditWord
                .map { _ in Mutation.setCurrentWord(self.wordUseCase.currentUnmemorizedWord) },
            globalAction.didDeleteWord
                .filter { $0.uuid == self.currentState.currentWord?.uuid }
                .map { _ in Mutation.setCurrentWord(self.wordUseCase.currentUnmemorizedWord) },
            globalAction.didResetWordList
                .map { _ in Mutation.setCurrentWord(self.wordUseCase.currentUnmemorizedWord) },
        ])
    }

    public func reduce(state: State, mutation: Mutation) -> State {
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
