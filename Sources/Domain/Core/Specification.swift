//
//  Specification.swift
//  Domain
//
//  Created by Jaewon Yun on 2/18/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

public protocol Specification {

    associatedtype EntityType: Entity

    /// `entity` 가 Specification 을 만족하는지 여부를 반환합니다.
    func isSatisfied(for entity: EntityType) async throws -> Bool
}
