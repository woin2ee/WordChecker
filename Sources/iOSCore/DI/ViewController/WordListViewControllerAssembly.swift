//
//  WordListViewControllerAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Swinject
import SwinjectExtension
import Then

final class WordListViewControllerAssembly: Assembly {

    func assemble(container: Container) {
        container.register(WordListViewController.self) { resolver in
            let reactor: WordListReactor = resolver.resolve()

            return .init().then {
                $0.reactor = reactor
            }
        }
    }

}
