//
//  RxBaseReusableCell.swift
//  iOSSupport
//
//  Created by Jaewon Yun on 12/2/23.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import RxSwift
import UIKit
import UIKitPlus

open class RxBaseReusableCell: UITableViewCell, ReuseIdentifying {

    /// Cell 이 재사용될 때 폐기할 subscriptions 를 모아놓는 disposeBag 입니다.
    ///
    /// `prepareForReuse()` 가 호출될 때 초기화 되면서 연관된 subscriptions 이 폐기됩니다.
    public var disposeBag: DisposeBag = .init()

    open override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = .init()
    }

}
