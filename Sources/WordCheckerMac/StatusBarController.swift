//
//  StatusBarController.swift
//  WordCheckerMac
//
//  Created by Jaewon Yun on 2/25/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import AppKit

final class StatusBarController {

    var statusItem: NSStatusItem

    init() {
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        statusItem.button?.image = .init(systemSymbolName: "star", accessibilityDescription: nil)
    }

}
