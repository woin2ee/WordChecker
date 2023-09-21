//
//  LanguageSettingViewModel.swift
//  Testing
//
//  Created by Jaewon Yun on 2023/09/19.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation
import RxSwift
import RxCocoa
import RxUtility

final class LanguageSettingViewModel: ViewModelType {

    let userSettingsUseCase: UserSettingsUseCaseProtocol

    let settingsDirection: SettingsDirection

    let currentSettingLocale: TranslationLanguage

    init(
        userSettingsUseCase: UserSettingsUseCaseProtocol,
        settingsDirection: SettingsDirection,
        currentSettingLocale: TranslationLanguage
    ) {
        self.userSettingsUseCase = userSettingsUseCase
        self.settingsDirection = settingsDirection
        self.currentSettingLocale = currentSettingLocale
    }

    func transform(input: Input) -> Output {
        let selectableLocales = Driver.just(TranslationLanguage.allCases)

        let currentTranslationLocale = userSettingsUseCase.currentTranslationLocale
            .asSignalOnErrorJustComplete()

        let didSelectCell = input.selectCell
            .map(\.row)
            .map { TranslationLanguage.allCases[$0] }
            .withLatestFrom(currentTranslationLocale) { selectedLocale, currentTranslationLocale -> (sourceLocale: TranslationLanguage, targetLocale: TranslationLanguage) in
                switch self.settingsDirection {
                case .sourceLanguage:
                    return (selectedLocale, currentTranslationLocale.target)
                case .targetLanguage:
                    return (currentTranslationLocale.source, selectedLocale)
                }
            }
            .flatMapLatest { newTranslationLocale in
                return self.userSettingsUseCase.updateTranslationLocale(source: newTranslationLocale.sourceLocale, target: newTranslationLocale.targetLocale)
                    .asSignalOnErrorJustComplete()
            }

        return .init(
            selectableLocales: selectableLocales,
            didSelectCell: didSelectCell
        )
    }

}

extension LanguageSettingViewModel {

    struct Input {

        let selectCell: Signal<IndexPath>

    }

    struct Output {

        let selectableLocales: Driver<[TranslationLanguage]>

        let didSelectCell: Signal<Void>

    }

}

extension LanguageSettingViewModel {

    enum SettingsDirection {

        case sourceLanguage

        case targetLanguage

    }

}
