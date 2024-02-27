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

    func save(_ word: Domain.Word) throws {
        try realm.write {
            realm.add(word.toObjectModel(), update: .modified)
        }
    }

    func getAllWords() -> [Domain.Word] {
        return findAll()
            .compactMap { try? $0.toDomain() }
    }

    func getWord(by uuid: UUID) -> Domain.Word? {
        return try? find(by: uuid)?.toDomain()
    }

    func getWords(by word: String) -> [Domain.Word] {
        let results = realm.objects(Word.self)
            .where { $0.word.equals(word, options: .caseInsensitive) }
            .compactMap { try? $0.toDomain() }
        return Array(results)
    }

    func deleteWord(by uuid: UUID) throws {
        guard let object = find(by: uuid) else {
            return
        }

        try realm.write {
            self.realm.delete(object)
        }
    }

    func getUnmemorizedList() -> [Domain.Word] {
        return findAll()
            .filter { $0.isMemorized == false }
            .compactMap { try? $0.toDomain() }
    }

    func getMemorizedList() -> [Domain.Word] {
        return findAll()
            .filter { $0.isMemorized == true }
            .compactMap { try? $0.toDomain() }
    }

    func reset(to wordList: [Domain.Word]) throws {
        try realm.write {
            self.realm.deleteAll()

            let newList = wordList.map { $0.toObjectModel() }
            self.realm.add(newList)
        }
    }
}

extension WordRepository {

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
