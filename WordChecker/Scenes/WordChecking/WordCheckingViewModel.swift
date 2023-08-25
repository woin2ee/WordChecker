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
    
}

final class WordCheckingViewModel {
    
    private let wcRealm: WCRepository
    
    @Published var currentWord: Word?
    
    private var wordList: CircularLinkedList<Word>
    
    init(wcRealm: WCRepository) {
        self.wcRealm = wcRealm
        self.wordList = .init(wcRealm.getAllWords().shuffled())
        if let firstWord = wordList.current {
            self.currentWord = firstWord
        }
    }
    
}

extension WordCheckingViewModel: WordCheckingViewModelInput {
    
    func updateWordList() {
        let currentWord = self.currentWord
        let updatedWordList = wcRealm.getAllWords().shuffled()
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
            self.currentWord = wordList.current
        }
    }
    
    func updateToNextWord() {
        currentWord = wordList.next()
    }
    
    func saveNewWord(_ word: String) {
        let word: Word = .init(word: word)
        try? wcRealm.saveWord(word)
        wordList.append(word)
        if wordList.count == 1 {
            currentWord = wordList.current
        }
    }
    
    func shuffleWordList() {
        repeat {
            wordList.shuffle()
        } while wordList.current == self.currentWord
        self.currentWord = wordList.current
    }
    
}
