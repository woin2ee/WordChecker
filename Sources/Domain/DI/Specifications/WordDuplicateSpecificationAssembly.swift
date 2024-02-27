//
//  WordDuplicateSpecificationAssembly.swift
//  Domain
//
//  Created by Jaewon Yun on 2/18/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Swinject
import SwinjectExtension

struct WordDuplicateSpecificationAssembly: Assembly {

    func assemble(container: Container) {
        container.register(WordDuplicateSpecification.self) { resolver in
            return .init(wordRepository: resolver.resolve())
        }
    }
}
