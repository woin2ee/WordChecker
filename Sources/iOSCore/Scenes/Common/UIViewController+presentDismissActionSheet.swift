//
//  UIViewController+presentDismissActionSheet.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/11.
//

import Localization
import UIKit

extension UIViewController {

    public func presentDismissActionSheet() {
        let actionSheetController: UIAlertController = .init(title: nil, message: nil, preferredStyle: .actionSheet)

        let discardChangesAction: UIAlertAction = .init(
            title: WCString.discardChanges,
            style: .destructive,
            handler: { [weak self] _ in self?.dismiss(animated: true) }
        )
        let cancelAction: UIAlertAction = .init(title: WCString.cancel, style: .cancel)

        actionSheetController.addAction(discardChangesAction)
        actionSheetController.addAction(cancelAction)

        self.present(actionSheetController, animated: true)
    }

}
