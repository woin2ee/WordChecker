//
//  WordDetailAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import IOSSupport
import Swinject
import SwinjectExtension
import Then
import UseCase_Word

public final class WordDetailAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(WordDetailReactor.self) { resolver, uuid in
            let wordUseCase: WordUseCase = resolver.resolve()

            return WordDetailReactor.init(
                uuid: uuid,
                globalAction: GlobalAction.shared,
                wordUseCase: wordUseCase
            )
        }

        container.register(WordDetailViewControllerProtocol.self) { (resolver, uuid: UUID) in
            let reactor: WordDetailReactor = resolver.resolve(argument: uuid)

            return WordDetailViewController.init().then {
                $0.reactor = reactor
            }
        }
    }

}
