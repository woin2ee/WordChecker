//
//  AppDelegate.swift
//  WordCheckerMac
//
//  Created by Jaewon Yun on 2/25/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Cocoa
import Domain
import Infrastructure
import Swinject
import SwinjectDIContainer

internal final class WordCheckerApplication: NSApplication {

    let appDelegate = AppDelegate()

    override init() {
        super.init()
        self.delegate = appDelegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@main
internal final class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBar: MenuConfigurator?

    func applicationDidFinishLaunching(_ notification: Notification) {
        initDIContainer()
        statusBar = .init()
    }

    func initDIContainer() {
        DIContainer.shared.assembler.apply(assemblies: [
            DomainAssembly(),
            InfrastructureAssembly(),
            WordCheckerMacAssembly(),
        ])
    }
}
