//
//  ExternalStoreUseCaseAssembly.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Swinject
import SwinjectExtension

final class ExternalStoreUseCaseAssembly: Assembly {

    func assemble(container: Container) {
        container.register(ExternalStoreUseCaseProtocol.self) { resolver in
            let wordRepository: WordRepositoryProtocol = resolver.resolve()
            let googleDriveRepository: GoogleDriveRepositoryProtocol = resolver.resolve()
            let unmemorizedWordListRepository: UnmemorizedWordListRepositoryProtocol = resolver.resolve()

            return GoogleDriveUseCase.init(
                wordRepository: wordRepository,
                googleDriveRepository: googleDriveRepository,
                unmemorizedWordListRepository: unmemorizedWordListRepository,
                userSettingsUseCase: resolver.resolve()
            )
        }
        .inObjectScope(.container)
    }

}
