//
//  ExternalStoreUseCaseProtocol.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/22.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain_Core
import Domain_GoogleDrive
import Foundation
import RxSwift

public protocol ExternalStoreUseCaseProtocol {

    /// 외부 저장소에 로그인합니다.
    func signInWithAuthorization(presenting: PresentingConfiguration) -> RxSwift.Single<Void>

    /// 외부 저장소에서 로그아웃합니다.
    func signOut()

    var hasSigned: Bool { get }

    /// 외부 저장소에 업로드합니다.
    /// - Parameter presenting: 외부 서비스에 로그인이 되어있지 않을 때 로그인 화면을 제시하는데 사용되는 구성
    func upload(presenting: PresentingConfiguration?) -> Observable<ProgressStatus>

    /// 외부 저장소에서 다운로드합니다.
    /// - Parameter presenting: 외부 서비스에 로그인이 되어있지 않을 때 로그인 화면을 제시하는데 사용되는 구성
    func download(presenting: PresentingConfiguration?) -> Observable<ProgressStatus>

    /// 이전에 로그인했던 사용자 복구를 시도합니다.
    func restoreSignIn() -> Observable<Void>

    /// 단어 목록을 동기화합니다.
    /// - Parameter strategy: 어떻게 동기화 할 것인지 결정하는 동기화 전략입니다.
    func syncWordList(using strategy: SyncStrategy) -> Single<Void>
}
