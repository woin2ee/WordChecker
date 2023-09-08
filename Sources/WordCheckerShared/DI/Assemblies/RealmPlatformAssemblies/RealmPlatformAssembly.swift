//
//  RealmPlatformAssembly.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Foundation
import RealmPlatform
import RealmSwift
import Swinject

final class RealmPlatformAssembly: Assembly {

    func assemble(container: Container) {
        registerWordRepository(container: container)
    }

}

extension RealmPlatformAssembly {

    func makeDefaultRealmConfiguration() -> Realm.Configuration {
        let newSchemaVersion: UInt64 = 9
        let config: Realm.Configuration = .init(
            schemaVersion: newSchemaVersion,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion <= 7, newSchemaVersion >= 8 {
                    self.migrate7to8(migration)
                }
                if oldSchemaVersion <= 8, newSchemaVersion >= 9 {
                    self.migrate8to9(migration)
                }
            }
        )
        return config
    }

    private func migrate7to8(_ migration: Migration) {
        migration.enumerateObjects(ofType: Word.className()) { _, newObject in
            newObject!["isMemorized"] = false
        }
    }

    private func migrate8to9(_ migration: Migration) {
        migration.enumerateObjects(ofType: Word.className()) { _, newObject in
            newObject!["uuid"] = UUID()
        }
    }

}
