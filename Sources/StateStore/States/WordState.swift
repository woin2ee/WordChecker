//
//  WordState.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Domain
import ReSwift

// MARK: - State

public struct WordState: StateType {

    public var wordList: [Word] = []

    var shuffledWordList: CircularLinkedList<Word> = .init()

    public var currentWord: Word?

}

// MARK: - Reducer

extension WordState {

    public struct Reducer: ReducerType {

        let wordUseCase: WordUseCaseProtocol

        public init(wordUseCase: WordUseCaseProtocol) {
            self.wordUseCase = wordUseCase
        }

        public func createNewState(action: Action, state: WordState?) -> WordState {
            var state: WordState = state ?? .init()

            switch action as? Actions {
            case .deleteWord(let index):
                handleDeleteWord(for: index, in: &state)
            case .editWord(let index, let newWord):
                handleEditWord(to: newWord, for: index, in: &state)
            case .addWord(let word):
                handleAddWord(word, in: &state)
            case .updateToNextWord:
                state.currentWord = state.shuffledWordList.next()
            case .updateToPreviousWord:
                state.currentWord = state.shuffledWordList.previous()
            case .shuffleWordList:
                handleShuffleWordList(in: &state)
            case .deleteCurrentWord:
                handleDeleteCurrentWord(in: &state)
            case .initState:
                state.wordList = wordUseCase.getWordList()
                state.shuffledWordList = .init(state.wordList.shuffled())
                state.currentWord = state.shuffledWordList.current
            case .none:
                break
            }

            return state
        }

        func handleAddWord(_ word: String, in state: inout WordState) {
            let newWord: Word = .init(word: word)
            state.wordList.append(newWord)
            state.shuffledWordList.append(newWord)
            if state.shuffledWordList.count == 1 {
                state.currentWord = state.shuffledWordList.current
            }
            wordUseCase.addNewWord(newWord)
        }

        func handleEditWord(to newWord: String, for index: IndexPath.Index, in state: inout WordState) {
            let updateTarget = state.wordList[index]
            updateTarget.word = newWord
            state.wordList[index].word = newWord
            wordUseCase.editWord(updateTarget)
        }

        func handleShuffleWordList(in state: inout WordState) {
            guard state.shuffledWordList.count > 1 else { return }
            repeat {
                state.shuffledWordList.shuffle()
            } while state.shuffledWordList.current == state.currentWord
            state.currentWord = state.shuffledWordList.current
        }

        func handleDeleteWord(for index: IndexPath.Index, in state: inout WordState) {
            let deleteTarget = state.wordList[index]
            state.wordList.remove(at: index)
            state.shuffledWordList.delete(deleteTarget)
            if state.currentWord == deleteTarget {
                state.currentWord = state.shuffledWordList.next()
            }
            wordUseCase.deleteWord(deleteTarget)
        }

        func handleDeleteCurrentWord(in state: inout WordState) {
            guard
                let currentWord = state.currentWord,
                let targetIndex = state.wordList.firstIndex(of: currentWord)
            else {
                return
            }
            state.wordList.remove(at: targetIndex)
            state.shuffledWordList.deleteCurrent()
            state.currentWord = state.shuffledWordList.current
            wordUseCase.deleteWord(currentWord)
        }

    }

}

// MARK: - Actions

extension WordState {

    public enum Actions: Action {

        case deleteWord(index: IndexPath.Index)

        case editWord(index: IndexPath.Index, newWord: String)

        case addWord(String)

        case updateToNextWord

        case updateToPreviousWord

        case shuffleWordList

        case deleteCurrentWord

        case initState

    }

}
