//
//  ReusableCell.swift
//  UserSettings
//
//  Created by Jaewon Yun on 11/27/23.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation

public protocol ReusableCell {

    /// `Cell` 을 구성하는 데이터들의 집합입니다.
    associatedtype Model

    /// A `reusableIdentifier` that will be used by `dequeueReusableCell(withIdentifier:for:)`.
    ///
    /// If you don't override, it's concrete class name.
    static var reusableIdentifier: String { get }

    func bind(model: Model)

}

extension ReusableCell {

    public static var reusableIdentifier: String {
        return .init(describing: Self.self)
    }

}
