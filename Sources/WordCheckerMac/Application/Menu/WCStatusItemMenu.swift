//
//  WCStatusItemMenu.swift
//  WordCheckerMac
//
//  Created by Jaewon Yun on 3/28/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import AppKit

internal final class WCStatusItemMenu: NSMenu {

    init() {
        super.init(title: "")
        addItems()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addItems() {
        let menuItem = NSMenuItem(title: "종료", action: #selector(terminateApp), keyEquivalent: "")
        menuItem.target = self
        self.addItem(menuItem)
    }

    @objc private func terminateApp() {
        NSApp.terminate(self)
    }
}
