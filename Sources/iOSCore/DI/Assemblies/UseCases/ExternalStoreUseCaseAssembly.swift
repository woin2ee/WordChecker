//
//  ExternalStoreUseCaseAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/09/22.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation
import Swinject

public final class ExternalStoreUseCaseAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(ExternalStoreUseCaseProtocol.self) { resolver in
            let wordRepository: WordRepositoryProtocol = resolver.resolve()
            let googleDriveRepository: GoogleDriveRepositoryProtocol = resolver.resolve()
            let state: UnmemorizedWordListStateProtocol = resolver.resolve()

            return GoogleDriveUseCase.init(
                wordRepository: wordRepository,
                googleDriveRepository: googleDriveRepository,
                unmemorizedWordListState: state
            )
        }
        .inObjectScope(.container)
    }

}
