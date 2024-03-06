//
//  makeDefaultRealmConfiguration.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/12.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import RealmSwift

internal func makeDefaultRealmConfiguration() -> Realm.Configuration {
    let newSchemaVersion: UInt64 = 9
    let config: Realm.Configuration = .init(
        schemaVersion: newSchemaVersion,
        migrationBlock: { migration, oldSchemaVersion in
            if oldSchemaVersion <= 7, newSchemaVersion >= 8 {
                migrate7to8(migration)
            }
            if oldSchemaVersion <= 8, newSchemaVersion >= 9 {
                migrate8to9(migration)
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
