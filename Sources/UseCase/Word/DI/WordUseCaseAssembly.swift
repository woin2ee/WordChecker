//
//  WordUseCaseAssembly.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Swinject
import SwinjectExtension

public final class WordUseCaseAssembly: Assembly {

    public init() {}
    
    public func assemble(container: Container) {
        container.register(WordUseCaseProtocol.self) { resolver in
            return WordUseCase(
                wordService: resolver.resolve(),
                localNotificationService: resolver.resolve()
            )
        }
        .inObjectScope(.container)
    }

}
