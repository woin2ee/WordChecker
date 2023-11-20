//
//  GoogleDriveRepositoryAssembly.swift
//  DataDriver
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Swinject

final class GoogleDriveRepositoryAssembly: Assembly {

    func assemble(container: Container) {
        container.register(GoogleDriveRepositoryProtocol.self) { _ in
            return GoogleDriveRepository.init(gidSignIn: .sharedInstance)
        }
        .inObjectScope(.container)
    }

}
