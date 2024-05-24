//
//  Module.swift
//  ProjectDescriptionHelpers
//
//  Created by Jaewon Yun on 4/3/24.
//

import Foundation

/// Modules in the project.
///
/// 특정 모듈의 이름을 얻으려면 다음과 같은 패턴을 따라야 합니다. 
///
///     Module.{ name }
///     or
///     Module.{ prefix }.{ suffix }
///
/// 예를 들면 다음과 같습니다.
///
///     Module.utility
///     // "Utility"
///
///     Module.domain.core
///     // "Domain_Core"
///
public struct Module {
    
    public struct DomainModule {
        public let core = "Domain_Core"
        public let word = "Domain_Word"
        public let localNotification = "Domain_LocalNotification"
        public let googleDrive = "Domain_GoogleDrive"
        public let userSettings = "Domain_UserSettings"
    }
    
    public static var domain = DomainModule()
    
    public struct UseCaseModule {
        public let word = "UseCase_Word"
        public let localNotification = "UseCase_LocalNotification"
        public let googleDrive = "UseCase_GoogleDrive"
        public let userSettings = "UseCase_UserSettings"
    }
    
    public static var useCase = UseCaseModule()
    
    public struct IOSSceneModule {
        public let wordChecking = "IOSScene_WordChecking"
        public let wordAddition = "IOSScene_WordAddition"
        public let wordDetail = "IOSScene_WordDetail"
        public let wordList = "IOSScene_WordList"
        public let userSettings = "IOSScene_UserSettings"
    }
    
    public static var iOSScene = IOSSceneModule()
    
    public static var iOSSupport = "IOSSupport"
    public static var iOSDriver = "IOSDriver"
    public static var iPhoneDriver = "IPhoneDriver"
    public static var iPadDriver = "IPadDriver"
    public static var utility = "Utility"
    public static var testsSupport = "TestsSupport"
    
    public static var wordChecker = "WordChecker"
    public static var wordCheckerDev = "WordCheckerDev"
    public static var wordCheckerMac = "WordCheckerMac"
    
    public static var container = "Container"
}
