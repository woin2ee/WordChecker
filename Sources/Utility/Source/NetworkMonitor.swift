//
//  NetworkMonitor.swift
//  Utility
//
//  Created by Jaewon Yun on 2023/11/13.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import Network

/// 인터넷 연결 상태를 모니터링하는 객체입니다.
///
/// 모니터링을 시작하기 위해서 `start()` 함수를 호출해야 합니다.
public final class NetworkMonitor {

    public static let shared: NetworkMonitor = .init()

    let queue: DispatchQueue = .global()
    let monitor: NWPathMonitor = .init()

    public private(set) var isEstablishedConnection: Bool = false

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                self?.isEstablishedConnection = true
            } else {
                self?.isEstablishedConnection = false
            }
        }

        monitor.start(queue: self.queue)
    }

    public static func start() {
        _ = NetworkMonitor.shared
    }

}
