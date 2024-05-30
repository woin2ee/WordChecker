//
//  WordChecking+ChangeWordSymbol.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/11.
//

import SFSafeSymbols
import UIKit

extension WordCheckingView {

    final class ChangeWordSymbol: UIImageView {

        init(direction: Direction) {
            super.init(frame: .zero)

            let symbolScale: UIImage.SymbolScale = .large
            let config: UIImage.SymbolConfiguration = .init(scale: symbolScale)
                .applying(UIImage.SymbolConfiguration(weight: .bold))

            switch direction {
            case .left:
                self.image = .init(systemSymbol: .chevronCompactLeft, withConfiguration: config)
            case .right:
                self.image = .init(systemSymbol: .chevronCompactRight, withConfiguration: config)
            }
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // swiftlint:disable:next nesting
        enum Direction {

            case left

            case right

        }

    }

}
