//
//  UnmemorizedWordListStateAssembly.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/06.
//

import Domain
import Foundation
import DataDriver
import Swinject

public final class UnmemorizedWordListStateAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(UnmemorizedWordListRepositoryProtocol.self) { _ in
            return UnmemorizedWordListRepository.init()
        }
        .inObjectScope(.container)
    }

}
