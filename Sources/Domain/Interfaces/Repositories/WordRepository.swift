//
//  WordRepository.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Foundation

public protocol WordRepositoryProtocol {

    func save(_ word: Word)

    func getAll() -> [Word]

    func get(by uuid: UUID) -> Word?

    func delete(_ word: Word)

    func getUnmemorizedList() -> [Word]

}
