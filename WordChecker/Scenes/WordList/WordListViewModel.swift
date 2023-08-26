//
//  WordListViewModel.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/25.
//

import Combine
import Foundation

protocol WordListViewModelInput {
    
    func deleteWord(for indexPath: IndexPath)
    
    func editWord(for indexPath: IndexPath, toNewWord newWord: String)
    
    func updateWordList()
    
}

final class WordListViewModel {
    
    private let wcRealm: WCRepository
    
    @Published var wordList: [Word]
    
    init(wcRealm: WCRepository) {
        self.wcRealm = wcRealm
        self.wordList = wcRealm.getAllWords()
    }
    
}

extension WordListViewModel: WordListViewModelInput {
    
    func updateWordList() {
        wordList = wcRealm.getAllWords()
    }
    
    func deleteWord(for indexPath: IndexPath) {
        let deleteTarget = wordList[indexPath.row]
        try? wcRealm.deleteWord(by: deleteTarget.objectID)
        wordList.remove(at: indexPath.row)
    }
    
    func editWord(for indexPath: IndexPath, toNewWord newWord: String) {
        let updateTarget = wordList[indexPath.row]
        try? wcRealm.updateWord(for: updateTarget.objectID, withNewWord: newWord)
        if let updatedObject = try? wcRealm.getWord(by: updateTarget.objectID) {
            wordList[indexPath.row] = updatedObject
        }
    }
    
}
