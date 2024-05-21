//
//  GoogleDriveServiceFake.swift
//  Testing
//
//  Created by Jaewon Yun on 2023/09/22.
//  Copyright © 2023 woin2ee. All rights reserved.
//

@testable import Domain_GoogleDrive
import Foundation
import RxSwift

public final class GoogleDriveServiceFake: GoogleDriveService {

    var backupFiles: [BackupFile]
    public var hasSigned: Bool
    public var isGrantedAppDataScope: Bool
    private let testEmail = "Lorem-ipsum@gmail.com"

    public init() {
        self.backupFiles = []
        self.hasSigned = false
        self.isGrantedAppDataScope = false
    }

    public func uploadBackupFile(_ backupFile: BackupFile) -> RxSwift.Single<Void> {
        guard hasSigned, isGrantedAppDataScope else {
            return .error(GoogleDriveServiceError.noSignedInUser)
        }

        backupFiles.append(backupFile)
        return .just(())
    }

    public func downloadLatestBackupFile(backupFileName: BackupFileName) -> RxSwift.Single<BackupFile> {
        guard hasSigned, isGrantedAppDataScope else {
            return .error(GoogleDriveServiceError.noSignedInUser)
        }

        guard let latestBackupFile = backupFiles.filter({ $0.name == backupFileName }).last else {
            return .error(GoogleDriveServiceError.noFileInDrive)
        }

        return .just(latestBackupFile)
    }

    public func deleteAllBackupFiles(named backupFileName: BackupFileName) -> RxSwift.Single<Void> {
        backupFiles.removeAll(where: { $0.name == backupFileName })
        return .just(())
    }

    public func signInWithAppDataScope(presenting: Domain_GoogleDrive.PresentingConfiguration) -> RxSwift.Single<Domain_GoogleDrive.Email?> {
        hasSigned = true
        isGrantedAppDataScope = true

        return .just(testEmail)
    }
    
    public var currentUserEmail: Domain_GoogleDrive.Email? {
        testEmail
    }
    
    public func restorePreviousSignIn() -> RxSwift.Single<Domain_GoogleDrive.Email?> {
        hasSigned = true
        isGrantedAppDataScope = true

        return .just(testEmail)
    }

    public func signOut() {
        hasSigned = false
        isGrantedAppDataScope = false
    }

    public func requestAppDataScopeAccess(presenting: PresentingConfiguration) -> RxSwift.Single<Void> {
        if !hasSigned {
            return .error(GoogleDriveServiceError.noSignedInUser)
        }

        isGrantedAppDataScope = true

        return .just(())
    }
}
