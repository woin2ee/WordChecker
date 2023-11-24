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

public final class GlobalAction {

    public static let shared: GlobalAction = .init()

    private init() {}

    public var didSetSourceLanguage: PublishRelay<TranslationLanguage> = .init()
    public var didSetTargetLanguage: PublishRelay<TranslationLanguage> = .init()

    public var didEditWord: PublishRelay<Word> = .init()
    public var didDeleteWord: PublishRelay<Word> = .init()
    public var didAddWord: PublishRelay<Void> = .init()

    public var didResetWordList: PublishRelay<Void> = .init()

}
