//
//  GoogleDriveRepositoryAssembly.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/22.
//

import Domain
import Foundation
import GoogleDrivePlatform
import Swinject

public final class GoogleDriveRepositoryAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(GoogleDriveRepositoryProtocol.self) { _ in
            return GoogleDriveRepository.init(gidSignIn: .sharedInstance)
        }
        .inObjectScope(.container)
    }

}
