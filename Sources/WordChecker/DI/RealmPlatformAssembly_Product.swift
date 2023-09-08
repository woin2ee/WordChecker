//
//  RealmPlatformAssembly_Product.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/31.
//

import Domain
import Foundation
import RealmPlatform
import RealmSwift
import Swinject

extension RealmPlatformAssembly {

    func registerWordRepository(container: Container) {
        container.register(WordRepositoryProtocol.self) { _ in
            var config: Realm.Configuration = self.makeDefaultRealmConfiguration()
            guard config.fileURL != nil else {
                fatalError("Realm's url is nil.")
            }
            config.fileURL?.deleteLastPathComponent()
            config.fileURL?.append(path: "WordCheckerProduct")
            config.fileURL?.appendPathExtension("realm")
            guard let realm: Realm = try? .init(configuration: config) else {
                fatalError("Failed to initialize.")
            }
            #if DEBUG
                print("Realm file url : \(realm.configuration.fileURL?.debugDescription ?? "nil")")
            #endif
            return WordRepository.init(realm: realm)
        }
        .inObjectScope(.container)
    }

}
