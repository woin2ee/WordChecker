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
        registerWCRepository(container: container)
    }

}

extension DataAssembly {

    func makeDefaultRealmConfiguration() -> Realm.Configuration {
        let config: Realm.Configuration = .init(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    migration.renameProperty(onType: Word.className(), from: "id", to: "objectID")
                }
            }
        )
        return config
    }

}
