//
//  GoogleDriveRepositoryProtocol.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/22.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

public protocol GoogleDriveRepositoryProtocol {

    func signInWithAppDataScope(presenting: PresentingConfiguration) -> RxSwift.Single<Void>

    func signOut()

    var hasSignIn: Bool { get }

    func restorePreviousSignIn() -> Result<Void, Error>

    func requestAccess(presenting: PresentingConfiguration) -> Single<Void>

    var isGrantedAppDataScope: Bool { get }

    func uploadWordList(_ wordList: [Word]) -> Single<Void>

    func downloadWordList() -> Single<[Word]>

}
