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
    func signInWithAppDataScope(presenting: PresentingConfiguration) -> Single<Email?>

    func signOut()

    var currentUserEmail: Email? { get }
    
    /// 로그인 여부를 반환합니다.
    var hasSigned: Bool { get }

    /// 이전에 로그인했던 사용자를 복구합니다.
    func restorePreviousSignIn() -> Single<Email?>

    /// App data scope 에 대한 접근 권한을 요청합니다.
    func requestAppDataScopeAccess(presenting: PresentingConfiguration) -> Single<Void>

    /// App data scope 에 접근 권한이 있는지 여부를 반환합니다.
    var isGrantedAppDataScope: Bool { get }

    /// Uploads a backup file to Google Drive.
    ///
    /// This method do not perform deleting for other files.
    ///
    /// - Parameter backupFile: The backup file to upload.
    /// - Returns: A Single emitting a Void value upon successful upload or an error upon failure.
    func uploadBackupFile(_ backupFile: BackupFile) -> Single<Void>

    /// Downloads the latest backup file from Google Drive.
    ///
    /// - Parameter backupFileName: The name of the backup file to download.
    /// - Returns: A Single emitting a BackupFile upon successful download or an error upon failure.
    func downloadLatestBackupFile(backupFileName: BackupFileName) -> Single<BackupFile>

    /// Deletes backup files from Google Drive.
    ///
    /// - Parameter backupFileName: The name of the backup files to delete.
    /// - Returns: A Single emitting a Void value upon successful deletion or an error upon failure.
    func deleteAllBackupFiles(named backupFileName: BackupFileName) -> Single<Void>
}
