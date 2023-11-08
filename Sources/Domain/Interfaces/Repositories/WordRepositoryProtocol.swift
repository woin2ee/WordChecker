//
//  WordRepository.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Foundation

public protocol WordRepositoryProtocol {

    /// 단어를 저장합니다. 이미 존재하는 UUID 를 가진 단어는 새로 업데이트됩니다.
    /// - Parameter word: 저장할 단어
    func save(_ word: Word)

    func getAll() -> [Word]

    func get(by uuid: UUID) -> Word?

    func delete(by uuid: UUID)

    func getUnmemorizedList() -> [Word]

    func getMemorizedList() -> [Word]

    func reset(to wordList: [Word])

}
