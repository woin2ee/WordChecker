//
//  BaseViewController.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/09.
//

import UIKit

open class BaseViewController: UIViewController {

    open override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        #if DEBUG
            self.checkDeallocation()
        #endif
    }
}
