//
//  LanguageSettingReactor.swift
//  LanguageSetting
//
//  Created by Jaewon Yun on 2/5/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Domain_UserSettings
import Foundation
import FoundationPlus
import IOSSupport
import ReactorKit
import UseCase_UserSettings

final class LanguageSettingReactor: Reactor {

    enum Action {
        case viewDidLoad
        case selectCell(IndexPath)
    }

    enum Mutation {
        case setSelectedCell(IndexPath)
    }

    struct State {
        let translationDirection: TranslationDirection
        var selectedCell: IndexPath
    }

    let initialState: State

    let userSettingsUseCase: UserSettingsUseCaseProtocol

    let globalAction: GlobalAction

    init(
        translationDirection: TranslationDirection,
        userSettingsUseCase: UserSettingsUseCaseProtocol,
        globalAction: GlobalAction
    ) {
        self.initialState = .init(translationDirection: translationDirection, selectedCell: .init())
        self.userSettingsUseCase = userSettingsUseCase
        self.globalAction = globalAction
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return userSettingsUseCase.getCurrentTranslationLocale()
                .asObservable()
                .map { (source: TranslationLanguage, target: TranslationLanguage) in
                    switch self.initialState.translationDirection {
                    case .sourceLanguage:
                        return source
                    case .targetLanguage:
                        return target
                    }
                }
                .map { currentSelectedLanguage in
                    return TranslationLanguage.allCases.index(of: currentSelectedLanguage)
                }
                .map { row in
                    return Mutation.setSelectedCell(.init(row: row, section: 0))
                }

        case .selectCell(let indexPath):
            let selectedLanguage = TranslationLanguage.allCases[indexPath.row]
            return userSettingsUseCase.getCurrentTranslationLocale()
                .asObservable()
                .map { (currentSource: TranslationLanguage, currentTarget: TranslationLanguage) -> (sourceLanguage: TranslationLanguage, targetLanguage: TranslationLanguage) in
                    switch self.initialState.translationDirection {
                    case .sourceLanguage:
                        return (selectedLanguage, currentTarget)
                    case .targetLanguage:
                        return (currentSource, selectedLanguage)
                    }
                }
                .doOnNext { newTranslationLanguage in
                    switch self.initialState.translationDirection {
                    case .sourceLanguage:
                        self.globalAction.didSetSourceLanguage.accept(newTranslationLanguage.sourceLanguage)
                    case .targetLanguage:
                        self.globalAction.didSetTargetLanguage.accept(newTranslationLanguage.targetLanguage)
                    }
                }
                .flatMapLatest { (sourceLanguage: TranslationLanguage, targetLanguage: TranslationLanguage) in
                    return self.userSettingsUseCase.updateTranslationLocale(source: sourceLanguage, target: targetLanguage)
                }
                .map { Mutation.setSelectedCell(indexPath) }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case .setSelectedCell(let indexPath):
            state.selectedCell = indexPath
        }

        return state
    }

}
