//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain_LocalNotificationTesting
import Domain_WordManagementTesting
import Domain_WordMemorizationTesting
import Swinject
@testable import UseCase_Word

public final class WordUseCaseFakeAssembly: Assembly {

    public init() {}
    
    public func assemble(container: Container) {
        container.register(WordUseCase.self) { _ in
            return DefaultWordUseCase(
                wordManagementService: FakeWordManagementService(),
                wordMemorizationService: FakeWordMemorizationService.fake(),
                localNotificationService: LocalNotificationServiceFake()
            )
        }
        .inObjectScope(.container)
    }

}
