//
//  WordAdditionAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Swinject
import SwinjectExtension
import UseCase_Word

public final class WordAdditionAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(WordAdditionViewControllerProtocol.self) { resolver in
            let wordUseCase: WordUseCaseProtocol = resolver.resolve()
            let viewModel: WordAdditionViewModel = .init(wordUseCase: wordUseCase)

            return WordAdditionViewController.init().then {
                $0.viewModel = viewModel
            }
        }
    }

}
