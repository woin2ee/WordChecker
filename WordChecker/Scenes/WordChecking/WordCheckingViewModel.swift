//
//  WordCheckingViewModel.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/24.
//

import Combine
import Foundation

//enum WordCheckingError: Error {
//
//    case someError
//
//}

protocol WordCheckingViewModelInput {
    
    func updateToNextWord()
    
    func saveNewWord(_ word: String)
    
    func updateWordList()
    
    func shuffleWordList()
    
    func deleteCurrentWord()
    
}

final class WordCheckingViewModel {
    
    private let wcRepository: WCRepository
    
    @Published var currentWord: Word?
    
    private var wordList: CircularLinkedList<Word>
    
    init(wcRepository: WCRepository) {
        self.wcRepository = wcRepository
        self.wordList = .init(wcRepository.getAllWords().shuffled())
        if let firstWord = wordList.current {
            self.currentWord = firstWord
        }
    }
    
}

extension WordCheckingViewModel: WordCheckingViewModelInput {
    
    func deleteCurrentWord() {
        guard let currentWord = self.currentWord else { return }
        wordList.deleteCurrent()
        self.currentWord = wordList.current
        try? wcRepository.deleteWord(by: currentWord.objectID)
    }
    
    func updateWordList() {
        let currentWord = self.currentWord
        let updatedWordList = wcRepository.getAllWords().shuffled()
        wordList = .init(updatedWordList)
        guard wordList.count > 0 else {
            self.currentWord = nil
            return
        }
        for _ in 0..<wordList.count {
            if wordList.next() == currentWord {
                self.currentWord = wordList.current
                return
            }
        }
        self.currentWord = wordList.current
    }
    
    func updateToNextWord() {
        currentWord = wordList.next()
    }
    
    func saveNewWord(_ word: String) {
        let word: Word = .init(word: word)
        try? wcRepository.saveWord(word)
        wordList.append(word)
        if wordList.count == 1 {
            currentWord = wordList.current
        }
    }
    
    func shuffleWordList() {
        guard wordList.count > 1 else { return }
        repeat {
            wordList.shuffle()
        } while wordList.current == self.currentWord
        self.currentWord = wordList.current
    }
    
}
