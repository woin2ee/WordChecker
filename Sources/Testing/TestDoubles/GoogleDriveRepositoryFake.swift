//
//  GoogleDriveRepositoryFake.swift
//  Testing
//
//  Created by Jaewon Yun on 2023/09/22.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import RxSwift
import Foundation

public final class GoogleDriveRepositoryFake: GoogleDriveRepositoryProtocol {

    public var _wordList: [Word] = []

    public init(sampleWordList: [Word] = []) {
        _wordList = sampleWordList
    }

    public func uploadWordList(_ wordList: [Word]) -> Single<Void> {
        _wordList = wordList
        return .just(())
    }

    public func downloadWordList() -> Single<[Word]> {
        return .just(_wordList)
    }

}
