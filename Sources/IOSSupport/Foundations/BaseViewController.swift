//
//  BaseViewController.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/09.
//

import UIKit

open class BaseViewController: UIViewController {

    public var performsDeallocationChecking: Bool = false
    
    public init() {
        super.init(nibName: nil, bundle: nil)
#if DEBUG
        self.performsDeallocationChecking = true
#endif
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

#if DEBUG
        if performsDeallocationChecking {
            self.checkDeallocation()
        }
#endif
    }
}
