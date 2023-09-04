//
//  WordStateAction.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Foundation
import ReSwift

enum WordStateAction: Action {

    case deleteWord(index: IndexPath.Index)

    case editWord(index: IndexPath.Index, newWord: String)

    case addWord(word: String)

    case updateToNextWord

    case updateToPreviousWord

    case shuffleWordList

    case deleteCurrentWord

}
