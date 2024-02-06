//
//  AppDelegate.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

import Domain
import iPhoneDriver
import Infrastructure

// Scenes
import GeneralSettings
import LanguageSetting
import PushNotificationSettings
import UserSettings
import WordAddition
import WordChecking
import WordDetail
import WordList

// DI
import Swinject
import SwinjectDIContainer

@main
class AppDelegate: iPhoneAppDelegate {

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
            InfrastructureAssembly(),
        ])
    }

}
