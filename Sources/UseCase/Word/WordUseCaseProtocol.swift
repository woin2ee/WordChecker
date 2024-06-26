//
//  WordUseCase.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Domain_WordManagement
import Domain_WordMemorization
import Foundation
import RxSwift

public protocol WordUseCase {

    /// 새 단어를 추가합니다.
    ///
    /// - Returns: 단어 추가에 성공하면 Next 이벤트를, 어떠한 이유로 인해 실패하면 `WordUseCaseError` 타입의 Error 이벤트를 방출하는 Sequence 를 반환합니다.
    func addNewWord(_ word: String) -> Single<Void>

    /// 단어를 삭제합니다.
    func deleteWord(by uuid: UUID) -> Single<Void>

    /// 저장된 모든 단어 목록을 가져옵니다.
    func fetchWordList() -> [Word]

    /// 암기 완료된 단어의 목록을 가져옵니다.
    func fetchMemorizedWordList() -> [Word]

    /// 암기중인 단어 목록을 가져옵니다.
    func fetchMemorizingWordList() -> [Word]
    
    /// 암기중인 단어 목록을 가져옵니다.
    func fetchMemorizingWordList() -> Infallible<[Word]>

    /// 특정 단어를 가져옵니다.
    func fetchWord(by uuid: UUID) -> Single<Word>

    /// 단어를 업데이트 합니다.
    func updateWord(by uuid: UUID, with newAttribute: WordAttribute) -> Single<Void>

    /// 암기되지 않은 단어 목록을 섞습니다.
    func shuffleUnmemorizedWordList()

    @discardableResult
    func updateToNextWord() -> MemorizingWord?
    
    @discardableResult
    func updateToPreviousWord() -> MemorizingWord?

    func markCurrentWordAsMemorized() -> Single<Void>
    
    func markWordsAsMemorized(by uuids: [UUID]) -> Single<Void>

    func getCurrentUnmemorizedWord() -> (word: MemorizingWord?, index: Int?)
    
    /// `word` 파라미터로 전달된 단어가 이미 저장된 단어인지 검사합니다.
    ///
    /// 대소문자가 다른 단어는 같은 단어로 취급합니다.
    ///
    /// - Returns: 이미 저장된 단어이면 `true` 를, 아니면 `false` 값의 next 이벤트를 방출하는 Sequence 를 반환합니다.
    /// - Throws: 파라미터로 전달된 문자열이 유효하지 않아서 저장될 수 없는 단어일 때 Error 를 방출합니다.
    func isWordDuplicated(_ word: String) -> Single<Bool>
    
    /// 이미 확인한 단어의 개수
    func getCheckedCount() -> Int
    
    /// 이미 확인한 단어의 개수
    func getCheckedCount() -> Infallible<Int>
    
    func initializeMemorizingList()
}
