//
//  RealmPlatformAssembly.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/12.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import RealmSwift
import Swinject
import Utility

internal final class WordRepositoryAssemblyDev: Assembly {

    func assemble(container: Container) {
        container.register(WordRepositoryProtocol.self) { _ in
            LaunchArgument.verify()

            if LaunchArgument.contains(.useInMemoryDatabase) {
                return self.makeInMemoryWordRepository()
            }

            if LaunchArgument.contains(.sampledDatabase) {
                return self.makeSampledWordRepository()
            }

            return self.makePersistenceWordRepository()
        }
        .inObjectScope(.container)
    }

    private func makeInMemoryWordRepository() -> WordRepository {
        let config: Realm.Configuration = .init(inMemoryIdentifier: "WordCheckerDev")
        
        let realm = realmExecutionQueue.sync {
            guard let realm: Realm = try? .init(configuration: config, queue: realmExecutionQueue) else {
                fatalError("Failed to initialize.")
            }
            return realm
        }
        
        return WordRepository(realm: realm, realmConfinedQueue: realmExecutionQueue)
    }

    private func makeSampledWordRepository() -> WordRepository {
        let config: Realm.Configuration = .init(inMemoryIdentifier: "WordCheckerDevSampled")
        
        let realm = realmExecutionQueue.sync {
            guard let realm: Realm = try? .init(configuration: config, queue: realmExecutionQueue) else {
                fatalError("Failed to initialize.")
            }
            return realm
        }
        
        do {
            try realmExecutionQueue.sync {
                try realm.write {
                    sampleWords
                        .map { WordObject.init(word: $0) }
                        .forEach { realm.add($0) }
                }
            }
        } catch {
            fatalError("Failed to create sample data.")
        }
        
        return WordRepository(realm: realm, realmConfinedQueue: realmExecutionQueue)
    }

    private func makePersistenceWordRepository() -> WordRepository {
        var config: Realm.Configuration = makeDefaultRealmConfiguration()
        guard config.fileURL != nil else {
            fatalError("Realm's url is nil.")
        }
        config.fileURL?.deleteLastPathComponent()
        config.fileURL?.append(path: "WordCheckerDev")
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

}

private let sampleWords: [String] = [
    "air conditioning",
    "art",
    "artist",
    "baby’s breath",
    "badminton",
    "baseball",
    "basketball",
    "bed",
    "biology",
    "black",
    "blue",
    "bookshelf",
    "boss",
    "buffalo",
    "cattle",
    "cheetah",
    "chemistry",
    "chicken",
    "chrysanthemum",
    "cleaning lady",
    "computer",
    "computer science",
    "cook",
    "coworker",
    "crocodile",
    "customer",
    "cycling",
    "daffodil",
    "daisy",
    "dandelion",
    "deer",
    "doctor",
    "document",
]
