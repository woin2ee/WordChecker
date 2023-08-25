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
    
}
