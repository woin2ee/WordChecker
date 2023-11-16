//
//  ViewControllerAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/10/01.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation
import Swinject
import Then

public final class ViewControllerAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        let assemblies: [Assembly] = [
            WordCheckingViewControllerAssembly(),
            WordListViewControllerAssembly(),
            WordDetailViewControllerAssembly(),
            WordAdditionViewControllerAssembly(),
            UserSettingsViewControllerAssembly(),
            LanguageSettingViewControllerAssembly(),
        ]

        assemblies.forEach { assembly in
            assembly.assemble(container: container)
        }
    }

}

final class LanguageSettingViewControllerAssembly: Assembly {

    func assemble(container: Container) {
        container.register(LanguageSettingViewController.self) { resolver, settingsDirection, currentSettingLocale in
            let userSettingsUseCase: UserSettingsUseCaseProtocol = resolver.resolve()
            let viewModel: LanguageSettingViewModel = .init(userSettingsUseCase: userSettingsUseCase, settingsDirection: settingsDirection, currentSettingLocale: currentSettingLocale)
            let viewController: LanguageSettingViewController = .init(viewModel: viewModel)
            return viewController
        }
    }

}

final class UserSettingsViewControllerAssembly: Assembly {

    func assemble(container: Container) {
        container.register(UserSettingsViewController.self) { resolver in
            let userSettingsUseCase: UserSettingsUseCaseProtocol = resolver.resolve()
            let externalStoreUseCase: ExternalStoreUseCaseProtocol = resolver.resolve()
            let viewModel: UserSettingsViewModel = .init(userSettingsUseCase: userSettingsUseCase, googleDriveUseCase: externalStoreUseCase)
            let viewController: UserSettingsViewController = .init(viewModel: viewModel)
            return viewController
        }
    }

}

final class WordAdditionViewControllerAssembly: Assembly {

    func assemble(container: Container) {
        container.register(WordAdditionViewController.self) { resolver in
            let wordUseCase: WordRxUseCaseProtocol = resolver.resolve()
            let viewModel: WordAdditionViewModel = .init(wordUseCase: wordUseCase)

            let viewController: WordAdditionViewController = .init(viewModel: viewModel)
            return viewController
        }
    }

}

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

final class WordDetailViewControllerAssembly: Assembly {

    func assemble(container: Container) {
        container.register(WordDetailViewController.self) { (resolver, uuid: UUID) in
            let reactor: WordDetailReactor = resolver.resolve(argument: uuid)

            return .init().then {
                $0.reactor = reactor
            }
        }
    }

}

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
