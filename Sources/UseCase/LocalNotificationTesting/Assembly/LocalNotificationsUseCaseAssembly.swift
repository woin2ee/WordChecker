//
//  Created by Jaewon Yun on 1/24/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Foundation
import Swinject
import SwinjectExtension
import UseCase_LocalNotification

public final class LocalNotificationsUseCaseMockAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(NotificationsUseCaseProtocol.self) { resolver in
            return NotificationsUseCaseMock(expectedAuthorizationStatus: .authorized)
        }
        .inObjectScope(.container)
    }
}
