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
    var mainWindow: MainWindow = DIContainer.shared.resolver.resolve()
    let menu = NSMenu()

    init() {
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.image = .init(systemSymbolName: "star", accessibilityDescription: nil)
        statusItem.button?.target = self
        statusItem.button?.action = #selector(didTapStatusItemButton(sender:))
        statusItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])

        let menuItem = NSMenuItem(title: "종료", action: #selector(terminateApp), keyEquivalent: "").then {
            $0.target = self
        }
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

            mainWindow.center()
            mainWindow.orderFrontRegardless()
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
