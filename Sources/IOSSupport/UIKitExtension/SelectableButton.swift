//
//  SelectableButton.swift
//  IOSScene_WordDetail
//
//  Created by Jaewon Yun on 4/28/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import UIKit

/// A button class that it is change appearance appropriately as selected state.
///
/// You can set follow color sets: `foregroundColorSet`, `backgroundColorSet`, `strokeColorSet`.
///
/// Each color set has two colors for `normal` and `selected` states.
///
/// If you specify any color set, The corresponding color set will apply inside the `updateConfiguration` method.
open class SelectableButton: UIButton {

    public struct SelectionColorSet {
        public let normalColor: UIColor
        public let selectedColor: UIColor
        
        func appropriateColor(as isSelected: Bool) -> UIColor {
            return isSelected ? selectedColor : normalColor
        }
        
        public init(normalColor: UIColor, selectedColor: UIColor) {
            self.normalColor = normalColor
            self.selectedColor = selectedColor
        }
    }
    
    public var backgroundColorSet: SelectionColorSet?
    public var strokeColorSet: SelectionColorSet?
    public var foregroundColorSet: SelectionColorSet?
    
    /// Update with the appropriate color based on the selected state.
    open override func updateConfiguration() {
        super.updateConfiguration()
        
        var buttonConfig = self.configuration ?? .bordered()
        var backgroundConfig = self.configuration?.background ?? .clear()
        
        if let foregroundColorSet = foregroundColorSet {
            buttonConfig.baseForegroundColor = foregroundColorSet.appropriateColor(as: self.isSelected)
        }
        if let backgroundColorSet = backgroundColorSet {
            buttonConfig.baseBackgroundColor = backgroundColorSet.appropriateColor(as: self.isSelected)
        }
        if let strokeColorSet = strokeColorSet {
            backgroundConfig.strokeColor = strokeColorSet.appropriateColor(as: self.isSelected)
        }
        
        buttonConfig.background = backgroundConfig
        self.configuration = buttonConfig
    }
    
    public init(
        backgroundColorSet: SelectionColorSet? = nil,
        strokeColorSet: SelectionColorSet? = nil,
        foregroundColorSet: SelectionColorSet? = nil
    ) {
        self.backgroundColorSet = backgroundColorSet
        self.strokeColorSet = strokeColorSet
        self.foregroundColorSet = foregroundColorSet
        super.init(frame: .zero)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
