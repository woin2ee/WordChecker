//
//  WordCell.swift
//  IOSScene_WordList
//
//  Created by Jaewon Yun on 5/14/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Domain_Word
import IOSSupport
import SFSafeSymbols
import SnapKit
import Then
import UIKit
import UIKitPlus

final class WordCell: UITableViewCell {
    
    struct Model {
        let word: String
        let memorizationState: MemorizationState
    }
    
    let wordLabel: UILabel
    let memorizedMarkerView: UIImageView
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        wordLabel = UILabel().then {
            $0.font = .preferredFont(ofSize: 18)
            $0.numberOfLines = 3
        }
        memorizedMarkerView = UIImageView(image: UIImage(systemSymbol: .checkmark))
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(wordLabel)
        contentView.addSubview(memorizedMarkerView)
        
        wordLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(18)
            make.verticalEdges.equalTo(contentView).inset(12)
            make.trailing.equalTo(memorizedMarkerView.snp.leading).offset(-14)
        }
        memorizedMarkerView.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).inset(12)
            make.centerY.equalTo(contentView)
            make.width.equalTo(memorizedMarkerView.snp.height)
            make.width.equalTo(26)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: Model) {
        wordLabel.text = model.word
        memorizedMarkerView.isHidden = model.memorizationState == .memorizing
    }
}
