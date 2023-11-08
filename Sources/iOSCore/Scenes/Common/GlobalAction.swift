//
//  GlobalAction.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/08.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation
import RxSwift
import RxCocoa

final class GlobalAction {

    static let shared: GlobalAction = .init()

    private init() {}

    var didSetSourceLanguage: PublishRelay<TranslationLanguage> = .init()
    var didSetTargetLanguage: PublishRelay<TranslationLanguage> = .init()

    var didEditWord: PublishRelay<Word> = .init()
    var didDeleteWord: PublishRelay<Word> = .init()

}
