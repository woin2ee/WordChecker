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

    private let wcRepository: WCRepository

    @Published var wordList: [Word]

    init(wcRepository: WCRepository) {
        self.wcRepository = wcRepository
        self.wordList = wcRepository.getAllWords()
    }

}

extension WordListViewModel: WordListViewModelInput {

    func updateWordList() {
        wordList = wcRepository.getAllWords()
    }

    func deleteWord(for indexPath: IndexPath) {
        let deleteTarget = wordList[indexPath.row]
        try? wcRepository.deleteWord(by: deleteTarget.objectID)
        wordList.remove(at: indexPath.row)
    }

    func editWord(for indexPath: IndexPath, toNewWord newWord: String) {
        let updateTarget = wordList[indexPath.row]
        try? wcRepository.updateWord(for: updateTarget.objectID, withNewWord: newWord)
        if let updatedObject = try? wcRepository.getWord(by: updateTarget.objectID) {
            wordList[indexPath.row] = updatedObject
        }
    }

}
