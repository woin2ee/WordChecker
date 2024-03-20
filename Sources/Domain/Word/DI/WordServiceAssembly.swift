//
//  WordServiceAssembly.swift
//  Service_Word
//
//  Created by Jaewon Yun on 3/21/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Foundation
import Swinject
import SwinjectExtension

internal struct WordServiceAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(WordService.self) { resolver in
            return WordService(
                wordRepository: resolver.resolve(),
                unmemorizedWordListRepository: resolver.resolve(),
                wordDuplicateSpecification: resolver.resolve()
            )
        }
    }
}
