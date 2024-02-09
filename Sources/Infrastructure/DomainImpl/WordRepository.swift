//
//  WordRepository.swift
//  RealmPlatform
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Domain
import Foundation
import Realm
import RealmSwift

final class WordRepository: WordRepositoryProtocol {

    let realm: Realm

    init(realm: Realm) {
        self.realm = realm
    }

    func save(_ word: Domain.Word) {
        if let updateTarget = find(by: word.uuid) {
            try? realm.write {
                updateTarget.word = word.word
                switch word.memorizedState {
                case .memorized:
                    updateTarget.isMemorized = true
                case .memorizing:
                    updateTarget.isMemorized = false
                }
            }
        } else {
            try? realm.write {
                realm.add(word.toObjectModel())
            }
        }
    }

    func getAllWords() -> [Domain.Word] {
        return findAll()
            .map { $0.toDomain() }
    }

    func getWord(by uuid: UUID) -> Domain.Word? {
        return find(by: uuid)?.toDomain() ?? nil
    }

    func deleteWord(by uuid: UUID) {
        guard let object = find(by: uuid) else {
            return
        }
        try? realm.write {
            self.realm.delete(object)
        }
    }

    func getUnmemorizedList() -> [Domain.Word] {
        return findAll()
            .filter { $0.isMemorized == false }
            .map { $0.toDomain() }
    }

    func getMemorizedList() -> [Domain.Word] {
        return findAll()
            .filter { $0.isMemorized == true }
            .map { $0.toDomain() }
    }

    func reset(to wordList: [Domain.Word]) {
        try? realm.write {
            let oldList = findAll()
            self.realm.delete(oldList)

            let newList = wordList.map { $0.toObjectModel() }
            self.realm.add(newList)
        }
    }

    private func find(by uuid: UUID) -> Word? {
        guard let object = realm.object(ofType: Word.self, forPrimaryKey: uuid) else {
            return nil
        }
        return object
    }

    private func findAll() -> [Word] {
        let words = realm.objects(Word.self)
        return Array(words)
    }

}
