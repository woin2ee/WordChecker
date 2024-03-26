//
//  GoogleDriveUseCaseAssembly.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Swinject
import SwinjectExtension

public final class GoogleDriveUseCaseAssembly: Assembly {

    public init() {}
    
    public func assemble(container: Container) {
        container.register(ExternalStoreUseCaseProtocol.self) { resolver in
            return ExternalStoreUseCase(
                googleDriveService: resolver.resolve(),
                wordService: resolver.resolve(),
                localNotificationService: resolver.resolve()
            )
        }
        .inObjectScope(.container)
    }
}
