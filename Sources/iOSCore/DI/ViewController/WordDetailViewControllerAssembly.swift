//
//  WordDetailViewControllerAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import Swinject
import SwinjectExtension
import Then

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
