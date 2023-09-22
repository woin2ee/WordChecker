//
//  UserSettingsViewModel.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/09/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation
import Localization
import RxSwift
import RxCocoa
import RxUtility

final class UserSettingsViewModel: ViewModelType {

    let userSettingsUseCase: UserSettingsUseCaseProtocol

    init(userSettingsUseCase: UserSettingsUseCaseProtocol) {
        self.userSettingsUseCase = userSettingsUseCase
    }

    func transform(input: Input) -> Output {
        let dataSource = userSettingsUseCase.currentUserSettingsRelay
            .unwrapOrThrow()
            .map { userSettings -> (source: TranslationLanguage, target: TranslationLanguage) in
                return (userSettings.translationSourceLocale, userSettings.translationTargetLocale)
            }
            .map { translationLocale -> [UserSettingsValueListModel] in
                return zip(
                    UserSettingsValueListModel.Style.allCases,
                    [translationLocale.source, translationLocale.target]
                )
                .map { itemType, translationLocale -> UserSettingsValueListModel in
                    return .init(itemType: itemType, value: translationLocale)
                }
            }
            .asDriverOnErrorJustComplete()

        return .init(
            userSettingsDataSource: dataSource
        )
    }

}

extension UserSettingsViewModel {

    struct Input {

    }

    struct Output {

        let userSettingsDataSource: Driver<[UserSettingsValueListModel]>

    }

}
