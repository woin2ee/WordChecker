//
//  UserSettingsUseCaseFake.swift
//  Testing
//
//  Created by Jaewon Yun on 2023/09/19.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation
import RxSwift
import RxRelay

public final class UserSettingsUseCaseFake: UserSettingsUseCaseProtocol {

    public var currentUserSettingsRelay: RxRelay.BehaviorRelay<Domain.UserSettings?> = .init(value: nil)

    public init() {}

    public func updateTranslationLocale(source sourceLocale: Domain.TranslationLanguage, target targetLocale: Domain.TranslationLanguage) -> RxSwift.Single<Void> {
        return .never()
    }

    public var currentTranslationLocale: RxSwift.Single<(source: Domain.TranslationLanguage, target: Domain.TranslationLanguage)> {
        return .never()
    }

    public func initUserSettings() -> RxSwift.Single<Domain.UserSettings> {
        return .never()
    }

    public var currentUserSettings: RxSwift.Single<Domain.UserSettings> {
        return .never()
    }

}
