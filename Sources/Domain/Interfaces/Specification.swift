//
//  Specification.swift
//  Domain
//
//  Created by Jaewon Yun on 2/18/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

protocol Specification {

    associatedtype Entity
    associatedtype Result

    /// `Entity` 가 Specification 을 만족하는지 여부를 반환합니다.
    func isSatisfied(for entity: Entity) -> Result
}
