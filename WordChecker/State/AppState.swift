//
//  AppState.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/03.
//

import Foundation
import ReSwift

struct AppState {

    var wordList: [Word]

    private var shuffledWordList: CircularLinkedList<Word>

    var currentWord: Word?

    static let reducer: Reducer<Self> = { action, state in
        let repository: WCRepository = DIContainer.shared.resolve()

        var state = state ?? initialAppState // TODO: How to Lazy 초기화?

        guard let action = action as? AppStateAction else {
            return state
        }

        switch action {
        case .deleteWord(let index):
            let deleteTarget = state.wordList[index]
            state.wordList.remove(at: index)
            state.shuffledWordList.delete(deleteTarget)
            if state.currentWord == deleteTarget {
                state.currentWord = state.shuffledWordList.next()
            }
            try? repository.deleteWord(by: deleteTarget.objectID)
        case .editWord(let index, let newWord):
            let updateTarget = state.wordList[index]
            try? repository.updateWord(for: updateTarget.objectID, withNewWord: newWord)
        case .addWord(let word):
            let newWord: Word = .init(word: word)
            state.wordList.append(newWord)
            state.shuffledWordList.append(newWord)
            if state.shuffledWordList.count == 1 {
                state.currentWord = state.shuffledWordList.current
            }
            try? repository.saveWord(newWord)
        case .updateToNextWord:
            state.currentWord = state.shuffledWordList.next()
        case .updateToPreviousWord:
            state.currentWord = state.shuffledWordList.previous()
        case .shuffleWordList:
            guard state.shuffledWordList.count > 1 else { break }
            repeat {
                state.shuffledWordList.shuffle()
            } while state.shuffledWordList.current == state.currentWord
            state.currentWord = state.shuffledWordList.current
        case .deleteCurrentWord:
            guard
                let currentWord = state.currentWord,
                let targetIndex = state.wordList.firstIndex(of: currentWord)
            else {
                break
            }
            state.wordList.remove(at: targetIndex)
            state.shuffledWordList.deleteCurrent()
            state.currentWord = state.shuffledWordList.current
            try? repository.deleteWord(by: currentWord.objectID)
        }

        return state
    }

    static var initialAppState: AppState {
        let repository: WCRepository = DIContainer.shared.resolve()

        let initialWordList = repository.getAllWords()
        let initialShuffledWordList: CircularLinkedList<Word> = .init(initialWordList.shuffled())
        let initialCurrentWord: Word? = initialShuffledWordList.count != 0 ? initialShuffledWordList.current : nil

        return .init(
            wordList: initialWordList,
            shuffledWordList: initialShuffledWordList,
            currentWord: initialCurrentWord
        )
    }

}
