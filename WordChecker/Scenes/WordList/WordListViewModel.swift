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
    
}

final class WordListViewModel {
    
    private let wcRealm: WCRepository
    
    @Published var words: [Word]
    
    init(wcRealm: WCRepository) {
        self.wcRealm = wcRealm
        self.words = wcRealm.getAllWords()
    }
    
}

extension WordListViewModel: WordListViewModelInput {
    
    func deleteWord(for indexPath: IndexPath) {
        let deleteTarget = words[indexPath.row]
        try? wcRealm.deleteWord(by: deleteTarget.objectID)
        words.remove(at: indexPath.row)
    }
    
    func editWord(for indexPath: IndexPath, toNewWord newWord: String) {
        let updateTarget = words[indexPath.row]
        try? wcRealm.updateWord(for: updateTarget.objectID, withNewWord: newWord)
        if let updatedObject = try? wcRealm.getWord(by: updateTarget.objectID) {
            words[indexPath.row] = updatedObject
        }
    }
    
}
