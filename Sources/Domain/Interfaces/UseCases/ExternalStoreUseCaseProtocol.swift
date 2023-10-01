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

    /// - Parameter presenting: 구글 드라이브 로그인이 되어있지 않을 때 로그인 화면을 제시하는데 사용되는 구성
    func upload(presenting: PresentingConfiguration?) -> Single<Void>

    /// - Parameter presenting: 구글 드라이브 로그인이 되어있지 않을 때 로그인 화면을 제시하는데 사용되는 구성
    func download(presenting: PresentingConfiguration?) -> Single<Void>

}
