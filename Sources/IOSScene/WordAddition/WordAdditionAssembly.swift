//
//  WordAdditionAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import IOSSupport
import Swinject
import SwinjectExtension
import UseCase_Word

public final class WordAdditionAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(WordAdditionViewControllerProtocol.self) { resolver in
            let viewModel = WordAdditionViewModel(
                wordUseCase: resolver.resolve(),
                globalState: GlobalState.shared
            )

            return WordAdditionViewController.init().then {
                $0.viewModel = viewModel
            }
        }
    }

}
