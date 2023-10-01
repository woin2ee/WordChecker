//
//  UIViewController+presentAlert.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/09/21.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import UIKit

extension UIViewController {

    func presentOKAlert(title: String?, message: String?, animated flag: Bool = true) {
        let actionController: UIAlertController = .init(title: title, message: message, preferredStyle: .alert)

        let okAction: UIAlertAction = .init(
            title: WCString.ok,
            style: .default
        )

        actionController.addAction(okAction)

        self.present(actionController, animated: true)
    }

}
