//
//  DI.swift
//  WordCheckerMac
//
//  Created by Jaewon Yun on 3/6/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Swinject
import SwinjectExtension
import SwinjectDIContainer

internal final class WordCheckerMacAssembly: Assembly {

    func assemble(container: Container) {
        container.register(MainView.self) { _ in
            return MainView()
        }
        container.register(MainViewController.self) { resolver in
            return MainViewController(
                ownView: resolver.resolve(),
                wordUseCase: resolver.resolve()
            )
        }
        container.register(MainWindow.self) { resolver in
            return MainWindow(mainViewController: resolver.resolve())
        }
    }
}
