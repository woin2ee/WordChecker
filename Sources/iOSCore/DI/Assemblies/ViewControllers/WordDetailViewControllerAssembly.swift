//
//  WordDetailViewControllerAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/10/01.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation
import Swinject

final class WordDetailViewControllerAssembly: Assembly {

    func assemble(container: Container) {
        container.register(WordDetailViewController.self) { (resolver, uuid: UUID, delegate: WordDetailReactorDelegate?) in
            let reactor: WordDetailReactor = resolver.resolve(arguments: uuid, delegate)
            
            let viewController: WordDetailViewController = .init()
            viewController.reactor = reactor
            return viewController
        }
    }

}
