//
//  UseCaseAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/09/21.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation
import Swinject

public final class UseCaseAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        let assemblies: [Assembly] = [
            WordUseCaseAssembly(),
            WordRxUseCaseAssembly(),
            UserSettingsUseCaseAssembly(),
            ExternalStoreUseCaseAssembly(),
        ]

        assemblies.forEach { assembly in
            assembly.assemble(container: container)
        }
    }

}

public final class ExternalStoreUseCaseAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(ExternalStoreUseCaseProtocol.self) { resolver in
            let wordRepository: WordRepositoryProtocol = resolver.resolve()
            let googleDriveRepository: GoogleDriveRepositoryProtocol = resolver.resolve()
            let unmemorizedWordListRepository: UnmemorizedWordListRepositoryProtocol = resolver.resolve()

            return GoogleDriveUseCase.init(
                wordRepository: wordRepository,
                googleDriveRepository: googleDriveRepository,
                unmemorizedWordListRepository: unmemorizedWordListRepository
            )
        }
        .inObjectScope(.container)
    }

}

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

public final class WordUseCaseAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(WordUseCaseProtocol.self) { resolver in
            let wordRepository: WordRepositoryProtocol = resolver.resolve()
            let unmemorizedWordListRepository: UnmemorizedWordListRepositoryProtocol = resolver.resolve()

            return WordUseCase.init(
                wordRepository: wordRepository,
                unmemorizedWordListRepository: unmemorizedWordListRepository
            )
        }
        .inObjectScope(.container)
    }

}

public final class WordRxUseCaseAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(WordRxUseCaseProtocol.self) { resolver in
            let wordUseCase: WordUseCaseProtocol = resolver.resolve()
            return WordRxUseCase.init(wordUseCase: wordUseCase)
        }
        .inObjectScope(.container)
    }

}
