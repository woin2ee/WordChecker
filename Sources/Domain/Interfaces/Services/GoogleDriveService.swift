//
//  GoogleDriveService.swift
//  Domain
//
//  Created by Jaewon Yun on 2/3/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Foundation
import RxSwift

public protocol GoogleDriveService {

    /// App data scope 를 가지고 로그인을 합니다.
    func signInWithAppDataScope(presenting: PresentingConfiguration) -> Single<Void>

    /// 로그아웃을 합니다.
    func signOut()

    /// 로그인 여부를 반환합니다.
    var hasSigned: Bool { get }

    /// 이전에 로그인했던 사용자를 복구합니다.
    func restorePreviousSignIn() -> Single<Void>

    /// App data scope 에 대한 접근 권한을 요청합니다.
    func requestAppDataScopeAccess(presenting: PresentingConfiguration) -> Single<Void>

    /// App data scope 에 접근 권한이 있는지 여부를 반환합니다.
    var isGrantedAppDataScope: Bool { get }

    /// 단어 목록을 업로드 합니다.
    func uploadWordList(_ wordList: [Word]) -> Single<Void>

    /// 단어 목록을 다운로드 합니다.
    func downloadWordList() -> Single<[Word]>

}
