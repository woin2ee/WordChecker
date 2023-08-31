//
//  DataAssembly.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/27.
//

import Foundation
import RealmSwift
import Swinject

final class DataAssembly: Assembly {

    func assemble(container: Container) {
        let arguments = ProcessInfo.processInfo.arguments
        if arguments.contains(LaunchArguments.useInMemoryDataBase.rawValue) {
            registerInMemoryWCRepository(container: container)
        } else {
            registerPersistentWCRepository(container: container)
        }
    }

    private func registerInMemoryWCRepository(container: Container) {
        container.register(WCRepository.self) { _ in
            let config: Realm.Configuration = .init(inMemoryIdentifier: "WordChecker")
            guard let realm: Realm = try? .init(configuration: config) else {
                fatalError("Failed to initialize.")
            }
            return .init(realm: realm)
        }
        .inObjectScope(.container)
    }

    private func registerPersistentWCRepository(container: Container) {
        container.register(WCRepository.self) { _ in
            let config: Realm.Configuration = .init(
                schemaVersion: 2,
                migrationBlock: { migration, oldSchemaVersion in
                    if oldSchemaVersion < 2 {
                        migration.renameProperty(onType: Word.className(), from: "id", to: "objectID")
                    }
                }
            )
            guard let realm: Realm = try? .init(configuration: config) else {
                fatalError("Failed to initialize.")
            }
            #if DEBUG
                print("Realm file url : \(realm.configuration.fileURL?.debugDescription ?? "nil")")
            #endif
            return .init(realm: realm)
        }
        .inObjectScope(.container)
    }

}
