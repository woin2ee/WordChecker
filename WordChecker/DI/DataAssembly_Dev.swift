//
//  DataAssembly_Dev.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/31.
//

import Foundation
import RealmSwift
import Swinject

extension DataAssembly {

    func registerWCRepository(container: Container) {
        container.register(WCRepository.self) { _ in
            // FIXME: 
//            let arguments = ProcessInfo.processInfo.arguments
            let config: Realm.Configuration = .init(inMemoryIdentifier: "WordChecker")
            guard let realm: Realm = try? .init(configuration: config) else {
                fatalError("Failed to initialize.")
            }
            return .init(realm: realm)
        }
        .inObjectScope(.container)
    }

}
