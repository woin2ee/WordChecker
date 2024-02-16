//
//  RealmPlatformAssembly.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/12.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation
import RealmSwift
import Swinject
import Utility

final class WordRepositoryAssemblyDev: Assembly {

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
        guard let realm: Realm = try? .init(configuration: config) else {
            fatalError("Failed to initialize.")
        }
        return WordRepository.init(realm: realm)
    }

    private func makeSampledWordRepository() -> WordRepository {
        let config: Realm.Configuration = .init(inMemoryIdentifier: "WordCheckerDevSampled")
        guard let realm: Realm = try? .init(configuration: config) else {
            fatalError("Failed to initialize.")
        }
        do {
            try realm.write {
                sampleWords
                    .map { Infrastructure.Word.init(word: $0) }
                    .forEach { realm.add($0) }
            }
        } catch {
            fatalError("Failed to create sample data.")
        }
        return WordRepository.init(realm: realm)
    }

    private func makePersistenceWordRepository() -> WordRepository {
        var config: Realm.Configuration = makeDefaultRealmConfiguration()
        guard config.fileURL != nil else {
            fatalError("Realm's url is nil.")
        }
        config.fileURL?.deleteLastPathComponent()
        config.fileURL?.append(path: "WordCheckerDev")
        config.fileURL?.appendPathExtension("realm")
        guard let realm: Realm = try? .init(configuration: config) else {
            fatalError("Failed to initialize.")
        }
        #if DEBUG
            print("Realm file url : \(realm.configuration.fileURL?.debugDescription ?? "nil")")
        #endif
        return WordRepository.init(realm: realm)
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