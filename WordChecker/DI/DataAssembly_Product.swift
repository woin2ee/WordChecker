//
//  DataAssembly_Product.swift
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
