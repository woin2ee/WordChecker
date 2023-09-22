//
//  GoogleDriveRepositoryProtocol.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/22.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import RxSwift

public protocol GoogleDriveRepositoryProtocol {

    func uploadWordList(_ wordList: [Word]) -> Single<Void>

    func downloadWordList() -> Single<[Word]>

}
