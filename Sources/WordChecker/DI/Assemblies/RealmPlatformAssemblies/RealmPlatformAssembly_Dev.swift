//
//  RealmPlatformAssembly_Dev.swift
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
            let arguments = ProcessInfo.processInfo.arguments
            // TODO: Insert [LaunchArguments 검증 code](상호배타적인것들)
            if arguments.contains(LaunchArguments.useInMemoryDatabase.rawValue) {
                return self.makeInMemoryWordRepository()
            }
            if arguments.contains(LaunchArguments.sampledDatabase.rawValue) {
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
                    .map { RealmPlatform.Word.init(word: $0) }
                    .forEach { realm.add($0) }
            }
        } catch {
            fatalError("Failed to create sample data.")
        }
        return WordRepository.init(realm: realm)
    }

    private func makePersistenceWordRepository() -> WordRepository {
        var config: Realm.Configuration = self.makeDefaultRealmConfiguration()
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
    "document"
]