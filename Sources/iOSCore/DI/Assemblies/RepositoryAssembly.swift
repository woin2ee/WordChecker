//
//  RepositoryAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/09/21.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import DataDriver
import Domain
import ExtendedUserDefaults
import Foundation
import RealmSwift
import Swinject

public final class RepositoryAssembly: Assembly {

    let userSettingsRepositoryAssembly: UserSettingsRepositoryAssembly
    let wordRepositoryAssembly: WordRepositoryAssembly

    public init(
        userSettingsRepositoryAssembly: UserSettingsRepositoryAssembly = .init(),
        wordRepositoryAssembly: WordRepositoryAssembly = .init()
    ) {
        self.userSettingsRepositoryAssembly = userSettingsRepositoryAssembly
        self.wordRepositoryAssembly = wordRepositoryAssembly
    }

    public func assemble(container: Container) {
        let assemblies: [Assembly] = [
            userSettingsRepositoryAssembly,
            wordRepositoryAssembly,
            UnmemorizedWordListStateAssembly(),
            GoogleDriveRepositoryAssembly(),
        ]

        assemblies.forEach { assembly in
            assembly.assemble(container: container)
        }
    }

}

public final class GoogleDriveRepositoryAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(GoogleDriveRepositoryProtocol.self) { _ in
            return GoogleDriveRepository.init(gidSignIn: .sharedInstance)
        }
        .inObjectScope(.container)
    }

}

public final class UnmemorizedWordListStateAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(UnmemorizedWordListRepositoryProtocol.self) { _ in
            return UnmemorizedWordListRepository.init()
        }
        .inObjectScope(.container)
    }

}

open class UserSettingsRepositoryAssembly: Assembly {

    public init() {}

    open func assemble(container: Container) {
        container.register(UserSettingsRepositoryProtocol.self) { _ in
            let userDefaults: ExtendedUserDefaults = .standard
            return UserSettingsRepository.init(userDefaults: userDefaults)
        }
        .inObjectScope(.container)
    }

}

open class WordRepositoryAssembly: Assembly {

    public init() {}

    open func assemble(container: Container) {
        container.register(WordRepositoryProtocol.self) { _ in
            var config: Realm.Configuration = makeDefaultRealmConfiguration()
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
