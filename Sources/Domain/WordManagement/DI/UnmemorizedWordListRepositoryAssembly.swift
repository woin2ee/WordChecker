//
//  UnmemorizedWordListRepositoryAssembly.swift
//  DataDriver
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Swinject

internal final class UnmemorizedWordListRepositoryAssembly: Assembly {

    func assemble(container: Container) {
        container.register(UnmemorizedWordListRepositoryProtocol.self) { _ in
            return UnmemorizedWordListRepository.init()
        }
        .inObjectScope(.container)
    }

}
