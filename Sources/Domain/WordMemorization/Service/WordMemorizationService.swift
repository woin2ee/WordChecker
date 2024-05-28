import Foundation

public protocol WordMemorizationService {
    
    /// 단어 목록을 섞고 첫번째 단어를 반환합니다.
    ///
    /// 목록 갯수가 2개 이상일 경우 항상 다른 첫번째 단어를 반환합니다.
    @discardableResult
    func shuffleList() -> MemorizingWord?

    /// 단어 목록을 설정합니다. 현재 위치가 목록의 가장 처음으로 설정됩니다.
    func setList(_ list: [MemorizingWord], shuffled: Bool)
    
    /// 현재 단어. 단어 목록이 비어있을때만 `nil`을 반환합니다.
    var current: MemorizingWord? { get }
    
    /// 다음 단어로 이동
    /// - Returns: 다음 단어
    @discardableResult
    func next() -> MemorizingWord?
    
    /// 이전 단어로 이동
    /// - Returns: 이전 단어
    @discardableResult
    func previous() -> MemorizingWord?
    
    /// 단어 목록 갯수
    var count: Int { get }
    
    /// 확인한 단어 갯수
    var checkedCount: Int { get }
    
    /// 아직 확인하지 않은 단어 갯수
    var unCheckedCount: Int { get }
    
    /// 현재 단어를 목록에서 삭제합니다.
    func deleteCurrent()
    
    /// `id`에 해당하는 단어를 목록에서 제거합니다.
    func deleteWord(by id: UUID)
    
    /// 모든 단어를 확인했는지 여부. 목록이 비어있으면 항상 `false` 입니다.
    var isCompletedAllChecking: Bool { get }
    
    /// 목록 마지막에 새 단어를 추가합니다.
    func appendWord(_ word: String, with id: UUID) throws
    
    /// 아직 확인하지 않은 목록 뒤쪽에 무작위로 새 단어를 추가합니다.
    func insertWord(_ word: String, with id: UUID) throws
    
    /// `id`가 일치하는 단어를 업데이트합니다.
    func updateWord(to word: String, with id: UUID)
}

// MARK: Default Value

public extension WordMemorizationService {
    
    func setList(_ list: [MemorizingWord], shuffled: Bool = true) {
        setList(list, shuffled: shuffled)
    }
}
