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
            return ExternalStoreUseCase.init(
                wordRepository: resolver.resolve(),
                unmemorizedWordListRepository: resolver.resolve(),
                googleDriveService: resolver.resolve(),
                notificationsUseCase: resolver.resolve()
            )
        }
        .inObjectScope(.container)
    }

}
