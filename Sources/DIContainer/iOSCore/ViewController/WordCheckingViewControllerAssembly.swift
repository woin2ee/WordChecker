//
//  WordCheckingViewControllerAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import iOSCore
import Swinject
import SwinjectExtension
import Then

final class WordCheckingViewControllerAssembly: Assembly {

    func assemble(container: Container) {
        container.register(WordCheckingViewController.self) { resolver in
            let reactor: WordCheckingReactor = resolver.resolve()

            return .init().then {
                $0.reactor = reactor
            }
        }
    }

}
