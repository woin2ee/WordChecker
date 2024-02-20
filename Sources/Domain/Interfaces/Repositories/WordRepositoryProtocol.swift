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
    func save(_ word: Word) throws

    func getAllWords() -> [Word]

    func getWord(by uuid: UUID) -> Word?

    /// 파라미터로 전달된 `word` 문자열과 일치하는 단어를 반환합니다.
    ///
    /// 문자열을 비교할 때 대소문자를 구분하지 않습니다.
    func getWords(by word: String) -> [Word]

    func deleteWord(by uuid: UUID) throws

    func getUnmemorizedList() -> [Word]

    func getMemorizedList() -> [Word]

    /// 모든 단어를 지우고 새로운 `wordList` 를 저장합니다.
    func reset(to wordList: [Word]) throws

}
