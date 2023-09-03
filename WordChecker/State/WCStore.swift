//
//  WCStore.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/03.
//

import Foundation
import ReSwift

struct WCStore {

    let shared: Store = .init(reducer: appReducer, state: nil)

    var wordList: [Word]

    init() {

    }

    func appReducer(action: Action, state: AppState?) -> AppState {
        var state = state ?? .init(wordList: [])

        guard let action = action as? AppStateAction else {
            return state
        }

        switch action {
        case .deleteWordAction(let index):
            state.wordList.remove(at: index)

            //        let deleteTarget = wordList[indexPath.row]
            //        try? wcRepository.deleteWord(by: deleteTarget.objectID)
            //        wordList.remove(at: indexPath.row)
        case .editWordAction(let index, let newWord):
            state.wordList[index].word = newWord

    //        let updateTarget = wordList[indexPath.row]
    //        try? wcRepository.updateWord(for: updateTarget.objectID, withNewWord: newWord)
    //        if let updatedObject = try? wcRepository.getWord(by: updateTarget.objectID) {
    //            wordList[indexPath.row] = updatedObject
    //        }
        }

        return state
    }

}

enum AppStateAction: Action {

    case deleteWordAction(index: IndexPath.Index)

    case editWordAction(index: IndexPath.Index, newWord: String)

}
