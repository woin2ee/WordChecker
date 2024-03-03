//
//  UIViewController+presentDismissActionSheet.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/11.
//

import UIKit

extension UIViewController {

    public func presentDismissActionSheet(discardChangesAction: (() -> Void)?) {
        let actionSheetController: UIAlertController = .init(title: nil, message: nil, preferredStyle: .actionSheet)

        let discardChangesAction: UIAlertAction = .init(
            title: LocalizedString.discardChanges,
            style: .destructive,
            handler: { _ in discardChangesAction?() }
        )
        let cancelAction: UIAlertAction = .init(title: LocalizedString.cancel, style: .cancel)

        actionSheetController.addAction(discardChangesAction)
        actionSheetController.addAction(cancelAction)

        self.present(actionSheetController, animated: true)
    }

}
