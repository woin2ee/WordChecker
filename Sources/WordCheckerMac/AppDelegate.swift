//
//  AppDelegate.swift
//  WordCheckerMac
//
//  Created by Jaewon Yun on 2/25/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBar: StatusBarController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBar = .init()
    }
}
