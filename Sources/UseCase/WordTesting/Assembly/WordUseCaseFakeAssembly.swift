//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Swinject
import UseCase_Word

public final class WordUseCaseFakeAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(WordUseCaseProtocol.self) { _ in
            return WordUseCaseFake()
        }
        .inObjectScope(.container)
    }

}
