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

public final class WordRepository: WordRepositoryProtocol {

    let realm: Realm

    public init(realm: Realm) {
        self.realm = realm
    }

    public func save(_ word: Domain.Word) {
        if let updateTarget = find(by: word.uuid) {
            try? realm.write {
                updateTarget.word = word.word
                updateTarget.isMemorized = word.isMemorized
            }
        } else {
            try? realm.write {
                realm.add(word.toObjectModel())
            }
        }
    }

    public func getAll() -> [Domain.Word] {
        return findAll()
            .map { $0.toDomain() }
    }

    public func get(by uuid: UUID) -> Domain.Word? {
        return find(by: uuid)?.toDomain() ?? nil
    }

    public func delete(by uuid: UUID) {
        guard let object = find(by: uuid) else {
            return
        }
        try? realm.write {
            self.realm.delete(object)
        }
    }

    public func getUnmemorizedList() -> [Domain.Word] {
        return findAll()
            .filter { $0.isMemorized == false }
            .map { $0.toDomain() }
    }

    public func getMemorizedList() -> [Domain.Word] {
        return findAll()
            .filter { $0.isMemorized == true }
            .map { $0.toDomain() }
    }

    func find(by uuid: UUID) -> Word? {
        guard let object = realm.object(ofType: Word.self, forPrimaryKey: uuid) else {
            return nil
        }
        return object
    }

    func findAll() -> [Word] {
        let words = realm.objects(Word.self)
        return Array(words)
    }

}
