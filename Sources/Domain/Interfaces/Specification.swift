//
//  Specification.swift
//  Domain
//
//  Created by Jaewon Yun on 2/18/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import RxSwift
import Utility

protocol Specification {

    associatedtype Entity

    /// `Entity` 가 Specification 을 만족하는지 여부를 반환합니다.
    func isSatisfied(for entity: Entity) -> Infallible<Bool>

    /// `Entity` 가 Specification 을 만족하는지 여부를 반환합니다.
    func isSatisfied(for entity: Entity) -> Bool
}

extension Specification {

    func isSatisfied(for entity: Entity) -> Infallible<Bool> {
        abstractMethod()
    }

    func isSatisfied(for entity: Entity) -> Bool {
        abstractMethod()
    }
}
