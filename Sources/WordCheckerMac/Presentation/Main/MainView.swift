//
//  MainView.swift
//  WordCheckerMac
//
//  Created by Jaewon Yun on 3/8/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Cocoa
import PinLayout
import Then

internal final class MainView: PinView {

    let width: CGFloat = 260
    let height: CGFloat = 72

    let titleLabel = NSTextField().then {
        $0.isEditable = false
        $0.isBezeled = false
        $0.stringValue = "단어 추가"
        $0.font = .preferredFont(forTextStyle: .title2)
    }

    let wordTextField = NSTextField().then {
        $0.placeholderString = "저장하려면 Enter 키를 입력하세요."
        $0.isAutomaticTextCompletionEnabled = false
        $0.lineBreakMode = .byTruncatingTail
    }

    let addButton = NSButton().then {
        $0.title = "추가"
    }

    init() {
        super.init(frame: NSRect(x: 0, y: 0, width: width, height: height))

        self.wantsLayer = true
        self.layer?.backgroundColor = .white

        self.addSubview(titleLabel)
        self.addSubview(wordTextField)
        self.addSubview(addButton)

        performLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func performLayout() {
        let padding: CGFloat = 10.0
        let minimumButtonWidth: CGFloat = 60.0

        titleLabel.pin.top().horizontally().margin(padding).sizeToFit(.width)
        addButton.pin.below(of: titleLabel, aligned: .right).bottom()
            .width(minimumButtonWidth).marginVertical(padding)
        wordTextField.pin.below(of: titleLabel, aligned: .left).before(of: addButton).bottom()
            .marginVertical(padding).marginRight(padding)
    }
}

#if DEBUG

import SwiftUI

private let width = MainView().width
private let height = MainView().height

private struct MainPreview: NSViewRepresentable {

    func makeNSView(context: Context) -> MainView {
        return MainView()
    }

    func updateNSView(_ nsView: MainView, context: Context) {}
}

#Preview {
    MainPreview()
        .frame(width: width, height: height)
}

#endif
