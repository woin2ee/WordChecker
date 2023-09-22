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
    let externalStoreUseCase: ExternalStoreUseCaseProtocol

    init(userSettingsUseCase: UserSettingsUseCaseProtocol, externalStoreUseCase: ExternalStoreUseCaseProtocol) {
        self.userSettingsUseCase = userSettingsUseCase
        self.externalStoreUseCase = externalStoreUseCase
    }

    func transform(input: Input) -> Output {
        let dataSource = userSettingsUseCase.currentUserSettingsRelay
            .unwrapOrThrow()
            .map { userSettings -> (source: TranslationLanguage, target: TranslationLanguage) in
                return (userSettings.translationSourceLocale, userSettings.translationTargetLocale)
            }
            .map { translationLocale -> [[UserSettingsItemModel]] in
                return [
                    [
                        .init(settingType: .changeSourceLanguage, value: translationLocale.source),
                        .init(settingType: .changeTargetLanguage, value: translationLocale.target),
                    ],
                    [
                        .init(settingType: .googleDriveUpload),
                        .init(settingType: .googleDriveDownload),
                    ],
                ]
            }
            .asDriverOnErrorJustComplete()

        let showLanguageSetting = input.selectItem
            .filter { $0.section == 0 }
            .withLatestFrom(dataSource.asSignalOnErrorJustComplete()) { indexPath, dataSource in
                dataSource[0][indexPath.row]
            }
            .map { selectedItemModel -> (settingsDirection: LanguageSettingViewModel.SettingsDirection, currentSettingLocale: TranslationLanguage)? in
                guard let currentSettingLocale = selectedItemModel.value else {
                    return nil
                }

                switch selectedItemModel.settingType {
                case .changeSourceLanguage:
                    return (.sourceLanguage, currentSettingLocale)
                case .changeTargetLanguage:
                    return (.targetLanguage, currentSettingLocale)
                default:
                    return nil
                }
            }
            .compactMap { $0 }
            .asSignalOnErrorJustComplete()

        let googleDriveUploadComplete = input.selectItem
            .filter { $0.section == 1 && $0.row == 0 }
            .mapToVoid()
            .withLatestFrom(input.presentingConfiguration)
            .flatMapFirst {
                return self.externalStoreUseCase.upload(presenting: $0)
                    .asSignalOnErrorJustComplete()
            }

        let googleDriveDownloadComplete = input.selectItem
            .filter { $0.section == 1 && $0.row == 1 }
            .mapToVoid()
            .withLatestFrom(input.presentingConfiguration)
            .flatMapFirst {
                return self.externalStoreUseCase.download(presenting: $0)
                    .asSignalOnErrorJustComplete()
            }

        return .init(
            userSettingsDataSource: dataSource,
            showLanguageSetting: showLanguageSetting,
            googleDriveUploadComplete: googleDriveUploadComplete,
            googleDriveDownloadComplete: googleDriveDownloadComplete
        )
    }

}

extension UserSettingsViewModel {

    struct Input {

        let selectItem: Signal<IndexPath>

        let presentingConfiguration: Driver<PresentingConfiguration>

    }

    struct Output {

        let userSettingsDataSource: Driver<[[UserSettingsItemModel]]>

        let showLanguageSetting: Signal<(settingsDirection: LanguageSettingViewModel.SettingsDirection, currentSettingLocale: TranslationLanguage)>

        let googleDriveUploadComplete: Signal<Void>

        let googleDriveDownloadComplete: Signal<Void>

    }

}

extension UserSettingsViewModel {

    enum InternalError: Error {

        case noCurrentSettingLocale

        case invalidSettingType
    }
}
