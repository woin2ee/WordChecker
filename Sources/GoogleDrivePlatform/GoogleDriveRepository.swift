//
//  GoogleDriveRepository.swift
//  GoogleDrivePlatform
//
//  Created by Jaewon Yun on 2023/09/22.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation
import GoogleSignIn
import RxSwift

public final class GoogleDriveRepository: GoogleDriveRepositoryProtocol {

    public func uploadWordList(_ wordList: [Domain.Word]) -> RxSwift.Single<Void> {
        // GoogleDrive 저장
        return .never()
    }

    public func downloadWordList() -> RxSwift.Single<[Domain.Word]> {
        // GoogleDrive 가져오기
        return .never()
    }

}
