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

    func signInWithAuthorization(presenting: PresentingConfiguration) -> RxSwift.Single<Void>

    func signOut()

    var hasSigned: Bool { get }

    /// - Parameter presenting: 외부 서비스에 로그인이 되어있지 않을 때 로그인 화면을 제시하는데 사용되는 구성
    func upload(presenting: PresentingConfiguration?) -> Observable<ProgressStatus>

    /// - Parameter presenting: 외부 서비스에 로그인이 되어있지 않을 때 로그인 화면을 제시하는데 사용되는 구성
    func download(presenting: PresentingConfiguration?) -> Observable<ProgressStatus>

    func restoreSignIn() -> Observable<Void>

}
