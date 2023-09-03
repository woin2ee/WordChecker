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
            var config: Realm.Configuration = self.makeDefaultRealmConfiguration()
            guard config.fileURL != nil else {
                fatalError("Realm's url is nil.")
            }
            // TODO: rename db file (데이터 유지하면서)
            config.fileURL?.deleteLastPathComponent()
            config.fileURL?.append(path: "WordChecker")
            config.fileURL?.appendPathExtension("realm")
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
