//
//  Coordinator.swift
//  Schalendar
//
//  Created by Jaewon Yun on 2023/05/03.
//

import Foundation
import UtilitySource

public protocol Coordinator: AnyObject {

    /// 상위 `Coordinator` 를 가리키는 프로퍼티입니다.
    ///
    /// - Warning: 순환참조가 일어나지 않도록 반드시 `weak` 변수로 선언해야 합니다.
    var parentCoordinator: Coordinator? { get set }

    /// 하위 flow 가 있을 경우 해당 하위 `Coordinator` 의 참조를 유지하는 배열입니다.
    var childCoordinators: [Coordinator] { get set }

    /// Start this coordinator.
    ///
    /// Coordinator 가 담당하는 View 가 화면에 Display 되며 실제로 메모리에 적재됨을 의미합니다.
    func start()
}

public extension Coordinator {

    func start() {
        abstractMethod()
    }
}
