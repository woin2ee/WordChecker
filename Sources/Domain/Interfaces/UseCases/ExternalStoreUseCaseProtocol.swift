//
//  ExternalStoreUseCaseProtocol.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/22.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import RxSwift

public protocol ExternalStoreUseCaseProtocol {

    func signInWithAppDataScope(presenting: PresentingConfiguration) -> RxSwift.Single<Void>

    func signOut()

    var hasSignIn: Bool { get }

    @discardableResult
    func restorePreviousSignIn() -> Result<Void, Error>

    func upload(presenting: PresentingConfiguration?) -> Single<Void>

    func download(presenting: PresentingConfiguration?) -> Single<Void>

}