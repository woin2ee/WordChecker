//
//  WordRepositoryAssembly.swift
//  DataDriver
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import RealmSwift
import Swinject

internal final class WordRepositoryAssembly: Assembly {

    func assemble(container: Container) {
        container.register(WordRepositoryProtocol.self) { _ in
            var config: Realm.Configuration = makeDefaultRealmConfiguration()
            guard config.fileURL != nil else {
                fatalError("Realm's url is nil.")
            }
            config.fileURL?.deleteLastPathComponent()
            config.fileURL?.append(path: "WordCheckerProduct")
            config.fileURL?.appendPathExtension("realm")

            let realm = realmExecutionQueue.sync {
                guard let realm: Realm = try? .init(configuration: config, queue: realmExecutionQueue) else {
                    fatalError("Failed to initialize.")
                }
                return realm
            }

            #if DEBUG
                print("Realm file url : \(realm.configuration.fileURL?.debugDescription ?? "nil")")
            #endif

            return WordRepository(realm: realm, realmConfinedQueue: realmExecutionQueue)
        }
        .inObjectScope(.container)
    }

}
