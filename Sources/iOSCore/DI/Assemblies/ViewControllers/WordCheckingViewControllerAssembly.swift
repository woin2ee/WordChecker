//
//  WordCheckingViewControllerAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/10/01.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Swinject

final class WordCheckingViewControllerAssembly: Assembly {

    func assemble(container: Container) {
        container.register(WordCheckingViewController.self) { resolver in
            let reactor: WordCheckingReactor = resolver.resolve()

            return WordCheckingViewController(reactor: reactor)
        }
    }

}
