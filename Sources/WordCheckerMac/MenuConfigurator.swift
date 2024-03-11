//
//  MenuConfigurator.swift
//  WordCheckerMac
//
//  Created by Jaewon Yun on 2/25/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import AppKit
import SwinjectExtension
import SwinjectDIContainer
import Then

internal final class MenuConfigurator {

    let statusItem: NSStatusItem
    let statusBarButton: NSStatusBarButton
    var mainWindow: MainWindow = DIContainer.shared.resolver.resolve()
    let menu = NSMenu()

    init() {
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.statusBarButton = statusItem.button ?? NSStatusBarButton()
        
        statusBarButton.image = .init(systemSymbolName: "star", accessibilityDescription: nil)
        statusBarButton.target = self
        statusBarButton.action = #selector(didTapStatusItemButton(sender:))
        statusBarButton.sendAction(on: [.leftMouseUp, .rightMouseUp])

        let menuItem = NSMenuItem(title: "종료", action: #selector(terminateApp), keyEquivalent: "")
        menuItem.target = self
        menu.addItem(menuItem)
    }

    deinit {
        NSStatusBar.system.removeStatusItem(statusItem)
    }

    @objc func didTapStatusItemButton(sender: NSStatusBarButton) {
        if NSApp.currentEvent?.type == .leftMouseUp {
            guard !mainWindow.isKeyWindow else {
                return
            }
            guard let statusBarButtonWindow = statusBarButton.window else {
                return
            }
            let frameOnScreen = statusBarButtonWindow.convertToScreen(statusBarButton.frame)
            mainWindow.setFrameTopLeftPoint(frameOnScreen.origin)
            mainWindow.makeKeyAndOrderFront(self)
            NSApp.activate()
        } else if NSApp.currentEvent?.type == .rightMouseUp {
            statusItem.menu = menu
            statusItem.button?.performClick(self)
            statusItem.menu = nil
        }
    }

    @objc func terminateApp() {
        NSApp.terminate(self)
    }
}
