//
//  RootSplitViewController.swift
//  IPadDriver
//
//  Created by Jaewon Yun on 4/11/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import UIKit

internal final class RootSplitViewController: UISplitViewController {

    static let shared: RootSplitViewController = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferredSplitBehavior = .tile
        self.preferredDisplayMode = .oneBesideSecondary
    }
}
