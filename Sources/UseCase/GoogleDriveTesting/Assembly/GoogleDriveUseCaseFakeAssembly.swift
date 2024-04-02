//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Swinject
import SwinjectExtension
import UseCase_GoogleDrive

public final class GoogleDriveUseCaseFakeAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(GoogleDriveUseCase.self) { resolver in
            return GoogleDriveUseCaseFake()
        }
        .inObjectScope(.container)
    }
}
