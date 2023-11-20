//
//  WordAdditionViewControllerAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Swinject
import SwinjectExtension

final class WordAdditionViewControllerAssembly: Assembly {

    func assemble(container: Container) {
        container.register(WordAdditionViewController.self) { resolver in
            let wordUseCase: WordRxUseCaseProtocol = resolver.resolve()
            let viewModel: WordAdditionViewModel = .init(wordUseCase: wordUseCase)

            return .init(viewModel: viewModel)
        }
    }

}
