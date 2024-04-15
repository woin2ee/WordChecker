//
//  UIViewController+.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/09/21.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import UIKit

extension UIViewController {

    public func presentOKAlert(title: String?, message: String?, animated flag: Bool = true) {
        let actionController: UIAlertController = .init(title: title, message: message, preferredStyle: .alert)

        let okAction: UIAlertAction = .init(
            title: LocalizedString.ok,
            style: .default
        )

        actionController.addAction(okAction)

        self.present(actionController, animated: true)
    }

    /// Dismiss 하기 전에 확인 Action sheet 를 제시합니다.
    ///
    /// - Parameter discardChangesAction: 변경 사항 폐기를 선택했을 때 실행되는 클로저.
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
    
    /// Dismiss 하기 전에 확인 Popover 를 제시합니다.
    /// - Parameters:
    ///   - anchorItem: The item on which to anchor the popover.
    ///   - discardChangesAction: 변경 사항 폐기를 선택했을 때 실행되는 클로저.
    public func presentDismissPopover(on anchorItem: (some UIPopoverPresentationControllerSourceItem), discardChangesAction: (() -> Void)?) {
        let actionSheetController: UIAlertController = .init(title: nil, message: nil, preferredStyle: .actionSheet)

        let discardChangesAction: UIAlertAction = .init(
            title: LocalizedString.discardChanges,
            style: .destructive,
            handler: { _ in discardChangesAction?() }
        )
        
        actionSheetController.addAction(discardChangesAction)
        actionSheetController.popoverPresentationController?.sourceItem = anchorItem
        
        self.present(actionSheetController, animated: true)
    }
}

#if DEBUG

extension UIViewController {

    public func checkDeallocation(afterDelay delay: TimeInterval = 1.0) {
        if isMovingFromParent || rootParentViewController.isBeingDismissed {
            let viewControllerType = type(of: self)
            let disappearanceSource: String = isMovingFromParent ? "removed from its parent" : "dismissed"

            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                assert(self == nil, "\(viewControllerType) not deallocated after being \(disappearanceSource).")
            }
        }
    }

    private var rootParentViewController: UIViewController {
        var root = self
        while let parent = root.parent {
            root = parent
        }
        return root
    }
}

#endif
