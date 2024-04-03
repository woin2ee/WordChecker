//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Swinject
import SwinjectExtension
import UseCase_UserSettings

public final class UserSettingsUseCaseFakeAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(UserSettingsUseCase.self) { resolver in
            return UserSettingsUseCaseFake()
        }
        .inObjectScope(.container)
    }
}
