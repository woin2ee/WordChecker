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
    /// - Returns: The system font associated with the specified text style.
    static func preferredFont(forTextStyle style: UIFont.TextStyle, weight: UIFont.Weight) -> UIFont {
        let metrics = UIFontMetrics.init(forTextStyle: style)
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font: UIFont = .systemFont(ofSize: descriptor.pointSize, weight: weight)
        return metrics.scaledFont(for: font)
    }
    
}
