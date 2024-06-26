//
//  MenuConfigurator.swift
//  WordCheckerMac
//
//  Created by Jaewon Yun on 2/25/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import AppKit
import Container
import Then

internal final class MenuConfigurator {

    let statusItem: NSStatusItem
    let statusBarButton: NSStatusBarButton
    var mainWindow: MainWindow = container.resolve()
    let menu: WCStatusItemMenu

    init() {
        menu = .init()
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.statusBarButton = statusItem.button ?? NSStatusBarButton()

        statusBarButton.image = .init(systemSymbolName: "star", accessibilityDescription: nil)
        statusBarButton.target = self
        statusBarButton.action = #selector(didTapStatusItemButton(sender:))
        statusBarButton.sendAction(on: [.leftMouseUp, .rightMouseUp])
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
}
