public protocol WordMemorizationService {
    
    /// 단어 목록을 섞고 첫번째 단어를 반환합니다.
    ///
    /// 목록 갯수가 2개 이상일 경우 항상 다른 첫번째 단어를 반환합니다.
    @discardableResult
    func shuffleList() -> Word?

    /// 단어 목록을 설정합니다.
    func setList(_ list: [Word], shuffled: Bool)
    
    /// 현재 단어. 단어 목록이 비어있을때만 `nil`을 반환합니다.
    var current: Word? { get }
    
    /// 다음 단어로 이동
    /// - Returns: 다음 단어
    @discardableResult
    func next() -> Word?
    
    /// 이전 단어로 이동
    /// - Returns: 이전 단어
    @discardableResult
    func previous() -> Word?
    
    /// 단어 목록 갯수
    var count: Int { get }
    
    /// 확인한 단어 갯수
    var checkedCount: Int { get }
    
    /// 아직 확인하지 않은 단어 갯수
    var unCheckedCount: Int { get }
    
    /// 현재 단어를 목록에서 삭제합니다.
    func deleteCurrent()
    
    var isCompletedAllChecking: Bool { get }
}

// MARK: Default Value

public extension WordMemorizationService {
    
    func setList(_ list: [Word], shuffled: Bool = true) {
        setList(list, shuffled: shuffled)
    }
}
