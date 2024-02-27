//
//  AppDelegate.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

import Domain
import IPhoneDriver
import Infrastructure

// Scenes
import IOSScene_GeneralSettings
import IOSScene_LanguageSetting
import IOSScene_PushNotificationSettings
import IOSScene_ThemeSetting
import IOSScene_UserSettings
import IOSScene_WordAddition
import IOSScene_WordChecking
import IOSScene_WordDetail
import IOSScene_WordList

// DI
import Swinject
import SwinjectDIContainer

@main
class AppDelegate: IPhoneAppDelegate {

    override func restoreGoogleSignInState() {
        // No restore for dev.
    }

    override func initDIContainer() {
        DIContainer.shared.assembler.apply(assemblies: [
            DomainAssembly(),
            InfrastructureAssemblyDev(),
            WordCheckingAssembly(),
            WordListAssembly(),
            WordDetailAssembly(),
            WordAdditionAssembly(),
            UserSettingsAssembly(),
            LanguageSettingAssembly(),
            PushNotificationSettingsAssemblyDev(),
            GeneralSettingsAssembly(),
            ThemeSettingAssembly(),
        ])
    }

}
