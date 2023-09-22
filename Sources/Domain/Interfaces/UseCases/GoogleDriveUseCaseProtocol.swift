//
//  GoogleDriveUseCaseProtocol.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/22.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import RxSwift

public protocol GoogleDriveUseCaseProtocol {

    func upload() -> Single<Void>

    func download() -> Single<Void>

}
