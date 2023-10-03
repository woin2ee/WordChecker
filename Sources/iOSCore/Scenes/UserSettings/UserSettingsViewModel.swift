//
//  UserSettingsViewModel.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/09/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation
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
        let hasSigned: BehaviorRelay<Bool> = .init(value: externalStoreUseCase.hasSigned)

        let currentTranslationSourceLanguage = userSettingsUseCase.currentUserSettingsRelay
            .asDriver()
            .compactMap(\.?.translationSourceLocale)

        let currentTranslationTargetLanguage = userSettingsUseCase.currentUserSettingsRelay
            .asDriver()
            .compactMap(\.?.translationTargetLocale)

        let uploadStatus = input.uploadTrigger
            .withLatestFrom(input.presentingConfiguration)
            .flatMapFirst {
                return self.externalStoreUseCase.signInWithAuthorization(presenting: $0)
                    .doOnSuccess { hasSigned.accept((true)) }
                    .asSignalOnErrorJustComplete()
            }
            .flatMapFirst {
                return self.externalStoreUseCase.upload(presenting: nil)
                    .asSignalOnErrorJustComplete()
            }

        let downloadStatus = input.downloadTrigger
            .withLatestFrom(input.presentingConfiguration)
            .flatMapFirst {
                return self.externalStoreUseCase.signInWithAuthorization(presenting: $0)
                    .doOnSuccess { hasSigned.accept((true)) }
                    .asSignalOnErrorJustComplete()
            }
            .flatMapFirst {
                return self.externalStoreUseCase.download(presenting: nil)
                    .asSignalOnErrorJustComplete()
            }

        let signOut = input.signOut
            .doOnNext {
                self.externalStoreUseCase.signOut()
                hasSigned.accept(false)
            }

        return .init(
            hasSigned: hasSigned.asDriver(),
            currentTranslationSourceLanguage: currentTranslationSourceLanguage,
            currentTranslationTargetLanguage: currentTranslationTargetLanguage,
            uploadStatus: uploadStatus,
            downloadStatus: downloadStatus,
            signOut: signOut
        )
    }

}

extension UserSettingsViewModel {

    struct Input {

        let uploadTrigger: Signal<Void>

        let downloadTrigger: Signal<Void>

        let signOut: Signal<Void>

        let presentingConfiguration: Driver<PresentingConfiguration>

    }

    struct Output {

        let hasSigned: Driver<Bool>

        let currentTranslationSourceLanguage: Driver<TranslationLanguage>

        let currentTranslationTargetLanguage: Driver<TranslationLanguage>

        let uploadStatus: Signal<ProgressStatus>

        let downloadStatus: Signal<ProgressStatus>

        let signOut: Signal<Void>

    }

}

extension UserSettingsViewModel {

    enum InternalError: Error {

        case noCurrentSettingLocale

        case invalidSettingType
    }
}
