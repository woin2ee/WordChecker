//
//  UserSettingsRepositoryFake.swift
//  Testing
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation
import RxSwift

public final class UserSettingsRepositoryFake: UserSettingsRepositoryProtocol {

    public var _userSettings: UserSettings

    public init(initialLocale: TranslationTargetLocale = .english) {
        self._userSettings = .init(translationTargetLocale: initialLocale)
    }

    public func saveUserSettings(_ userSettings: Domain.UserSettings) -> RxSwift.Single<Void> {
        return .create { result in
            self._userSettings = userSettings
            result(.success(()))
            return Disposables.create()
        }
    }

    public func getUserSettings() -> RxSwift.Single<Domain.UserSettings> {
        return .create { result in
            result(.success(self._userSettings))
            return Disposables.create()
        }
    }

}
