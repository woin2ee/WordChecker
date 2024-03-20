//
//  GoogleDriveServiceError.swift
//  Service_ExternalStorage
//
//  Created by Jaewon Yun on 3/20/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Foundation

internal enum GoogleDriveServiceError: Error {

    /// 로그인 복구 실패
    case failedRestorePreviousSignIn

    /// 로그인 실패
    case failedSignIn

    /// 로그인 화면 제시가 불가능한 윈도우
    case unSupportedWindow

    case noClientID

    case denyAccess

    /// 로그인 되어있지 않음
    case noSignedInUser

    /// 구글 드라이브에 파일이 없음
    case noFileInDrive
}
