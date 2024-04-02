//
//  Created by Jaewon Yun on 4/1/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Swinject

public struct IOSSceneUserSettingsAssemblyDev: Assembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        let subAsseblies: [Assembly] = [
            GeneralSettingsAssembly(),
            LanguageSettingAssembly(),
            PushNotificationSettingsAssemblyDev(),
            ThemeSettingAssembly(),
            UserSettingsAssembly(),
        ]
        subAsseblies.forEach { assembly in
            assembly.assemble(container: container)
        }
    }
}
