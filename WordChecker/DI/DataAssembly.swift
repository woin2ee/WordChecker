//
//  DataAssembly.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/27.
//

import Swinject

final class DataAssembly: Assembly {

    func assemble(container: Container) {
        registerWCRepository(container: container)
    }

}
