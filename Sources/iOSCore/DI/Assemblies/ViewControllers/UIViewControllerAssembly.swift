//
//  UIViewControllerAssembly.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/27.
//

import Domain
import Foundation
import Swinject

public final class UIViewControllerAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(WordCheckingViewController.self) { resolver, delegate in
            let wordUseCase: WordUseCaseProtocol = resolver.resolve()
            let userSettingsUseCase: UserSettingsUseCaseProtocol = resolver.resolve()
            let state: UnmemorizedWordListStateProtocol = resolver.resolve()
            let viewModel: WordCheckingViewModelProtocol = WordCheckingViewModel.init(wordUseCase: wordUseCase, userSettingsUseCase: userSettingsUseCase, state: state, delegate: delegate)
            let viewController: WordCheckingViewController = .init(viewModel: viewModel)
            return viewController
        }

        container.register(WordListViewController.self) { resolver in
            let wordUseCase: WordUseCaseProtocol = resolver.resolve()
            let viewModel: WordListViewModelProtocol = WordListViewModel.init(wordUseCase: wordUseCase)
            let viewController: WordListViewController = .init(viewModel: viewModel)
            return viewController
        }

        container.register(WordDetailViewController.self) { resolver, uuid, delegate in
            let wordUseCase: WordUseCaseProtocol = resolver.resolve()
            let viewModel: WordDetailViewModelProtocol = WordDetailViewModel.init(
                wordUseCase: wordUseCase,
                uuid: uuid,
                delegate: delegate
            )
            let viewController: WordDetailViewController = .init(viewModel: viewModel)
            return viewController
        }

        container.register(WordAdditionViewController.self) { resolver, delegate in
            let wordUseCase: WordRxUseCaseProtocol = resolver.resolve()
            let viewModel: WordAdditionViewModel = .init(wordUseCase: wordUseCase, delegate: delegate)
            let viewController: WordAdditionViewController = .init(viewModel: viewModel)
            return viewController
        }

        container.register(UserSettingsViewController.self) { resolver in
            let userSettingsUseCase: UserSettingsUseCaseProtocol = resolver.resolve()
            let externalStoreUseCase: ExternalStoreUseCaseProtocol = resolver.resolve()
            let viewModel: UserSettingsViewModel = .init(userSettingsUseCase: userSettingsUseCase, externalStoreUseCase: externalStoreUseCase)
            let viewController: UserSettingsViewController = .init(viewModel: viewModel)
            return viewController
        }

        container.register(LanguageSettingViewController.self) { resolver, settingsDirection, currentSettingLocale in
            let userSettingsUseCase: UserSettingsUseCaseProtocol = resolver.resolve()
            let viewModel: LanguageSettingViewModel = .init(userSettingsUseCase: userSettingsUseCase, settingsDirection: settingsDirection, currentSettingLocale: currentSettingLocale)
            let viewController: LanguageSettingViewController = .init(viewModel: viewModel)
            return viewController
        }
    }

}
