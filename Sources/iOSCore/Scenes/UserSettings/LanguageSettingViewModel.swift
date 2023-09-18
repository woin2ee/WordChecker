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

    init(userSettingsUseCase: UserSettingsUseCaseProtocol, settingsDirection: SettingsDirection) {
        self.userSettingsUseCase = userSettingsUseCase
        self.settingsDirection = settingsDirection
    }

    func transform(input: Input) -> Output {
        let selectableLocales = Driver.just(TranslationLocale.allCases)

        let currentTranslationLocale = userSettingsUseCase.currentTranslationLocale
            .asSignalOnErrorJustComplete()

        let didSelectCell = input.selectCell
            .map(\.row)
            .map { TranslationLocale.allCases[$0] }
            .withLatestFrom(currentTranslationLocale) { selectedLocale, currentTranslationLocale -> (sourceLocale: TranslationLocale, targetLocale: TranslationLocale) in
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

        return .init(selectableLocales: selectableLocales, didSelectCell: didSelectCell)
    }

}

extension LanguageSettingViewModel {

    struct Input {

        let selectCell: Signal<IndexPath>

    }

    struct Output {

        let selectableLocales: Driver<[TranslationLocale]>

        let didSelectCell: Signal<Void>

    }

}

extension LanguageSettingViewModel {

    enum SettingsDirection {

        case sourceLanguage

        case targetLanguage

    }

}
