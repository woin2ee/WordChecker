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

public final class UserSettingsUseCaseFake: UserSettingsUseCaseProtocol {

    public init() {}

    public func updateTranslationTargetLocale(to locale: Domain.TranslationLocale) -> RxSwift.Single<Void> {
        return .never()
    }

    public var currentTranslationTargetLocale: RxSwift.Single<Domain.TranslationLocale> {
        return .never()
    }

    public func initUserSettings() -> RxSwift.Single<Domain.UserSettings> {
        return .never()
    }

    public var currentUserSettings: RxSwift.Single<Domain.UserSettings> {
        return .never()
    }

}
