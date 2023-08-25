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
    
}

final class WordCheckingViewModel {
    
    private let wcRealm: WCRepository
    
    @Published var currentWord: Word?
    
    private var words: CircularLinkedList<Word>
    
    init(wcRealm: WCRepository) {
        self.wcRealm = wcRealm
        self.words = .init(wcRealm.getAllWords().shuffled())
        if let firstWord = words.current {
            self.currentWord = firstWord
        }
    }
    
}

extension WordCheckingViewModel: WordCheckingViewModelInput {
    
    func updateWordList() {
        let currentWord = self.currentWord
        let updatedWordList = wcRealm.getAllWords().shuffled()
        words = .init(updatedWordList)
        guard words.count > 0 else {
            self.currentWord = nil
            return
        }
        for _ in 0..<words.count {
            if words.next() == currentWord {
                self.currentWord = words.current
                return
            }
            self.currentWord = words.current
        }
    }
    
    func updateToNextWord() {
        currentWord = words.next()
    }
    
    func saveNewWord(_ word: String) {
        let word: Word = .init(word: word)
        try? wcRealm.saveWord(word)
        words.append(word)
        if words.count == 1 {
            currentWord = words.current
        }
    }
    
}
