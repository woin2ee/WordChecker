//
//  AppDelegate.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

import IPhoneDriver

// Domain
import Domain_GoogleDrive
import Domain_LocalNotification
import Domain_UserSettings
import Domain_Word

// UseCase
import UseCase_GoogleDrive
import UseCase_LocalNotification
import UseCase_UserSettings
import UseCase_Word

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
            // Domain
            DomainGoogleDriveAssembly(),
            DomainLocalNotificationAssembly(),
            DomainUserSettingsAssemblyDev(),
            DomainWordAssemblyDev(),

            // UseCase
            GoogleDriveUseCaseAssembly(),
            LocalNotificationsUseCaseAssembly(),
            UserSettingsUseCaseAssembly(),
            WordUseCaseAssembly(),

            // IOSScene
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
