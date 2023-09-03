//
//  Actions.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/03.
//

import Foundation
import ReSwift

enum AppStateAction: Action {

    case deleteWord(index: IndexPath.Index)

    case editWord(index: IndexPath.Index, newWord: String)

    case addWord(word: String)

    case updateToNextWord

    case updateToPreviousWord

    case shuffleWordList

    case deleteCurrentWord

}
