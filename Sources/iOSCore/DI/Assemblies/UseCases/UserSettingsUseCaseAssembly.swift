//
//  UseCaseAssembly.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/05.
//

import Domain
import Foundation
import Swinject

public final class UserSettingsUseCaseAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(UserSettingsUseCaseProtocol.self) { resolver in
            let userSettingsRepository: UserSettingsRepositoryProtocol = resolver.resolve()
            return UserSettingsUseCase.init(userSettingsRepository: userSettingsRepository)
        }
        .inObjectScope(.container)
    }

}
