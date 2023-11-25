//
//  UIFont+.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/15.
//

import UIKit

extension UIFont {

    /// Returns an instance of the system font for the specified text style with scaling for the user's selected content size category and weight.
    /// - Parameters:
    ///   - style: The text style for which to return a font. See UIFont.TextStyle for recognized values.
    ///   - weight: The weight of the font, specified as a font weight constant. For a list of possible values, see "Font Weights” in UIFontDescriptor. Avoid passing an arbitrary floating-point number for weight, because a font might not include a variant for every weight.
    ///   - maximumPointSize: The maximum point size allowed for the font. Use this value to constrain the font to the specified size when your interface cannot accommodate text that is any larger.
    /// - Returns: The system font associated with the specified text style.
    public static func preferredFont(forTextStyle style: UIFont.TextStyle, weight: UIFont.Weight, maximumPointSize: CGFloat? = nil) -> UIFont {
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font: UIFont = .systemFont(ofSize: fontDescriptor.pointSize, weight: weight)

        if let maximumPointSize = maximumPointSize {
            return style.metrics.scaledFont(for: font, maximumPointSize: maximumPointSize)
        } else {
            return style.metrics.scaledFont(for: font)
        }
    }

}
