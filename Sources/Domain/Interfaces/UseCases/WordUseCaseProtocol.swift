//
//  WordUseCaseProtocol.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Foundation
import RxSwift

public protocol WordUseCaseProtocol {

    /// 새 단어를 추가합니다.
    func addNewWord(_ word: Word) -> Single<Void>

    /// 단어를 삭제합니다.
    func deleteWord(by uuid: UUID) -> Single<Void>

    /// 저장된 모든 단어 목록을 가져옵니다.
    func getWordList() -> Single<[Word]>

    /// 암기 완료된 단어의 목록을 가져옵니다.
    func getMemorizedWordList() -> Single<[Word]>

    /// 암기되지 않은 단어의 목록을 가져옵니다.
    func getUnmemorizedWordList() -> Single<[Word]>

    /// 특정 단어를 가져옵니다.
    func getWord(by uuid: UUID) -> Single<Word>

    /// 단어를 업데이트 합니다.
    func updateWord(by uuid: UUID, to newWord: Word) -> Single<Void>

    /// 암기되지 않은 단어 목록을 섞습니다.
    func shuffleUnmemorizedWordList() -> Single<Void>

    func updateToNextWord() -> Single<Void>

    func updateToPreviousWord() -> Single<Void>

    func markCurrentWordAsMemorized(uuid: UUID) -> Single<Void>

    func getCurrentUnmemorizedWord() -> Single<Word>

}
