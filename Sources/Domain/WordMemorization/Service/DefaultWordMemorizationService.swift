import Foundation
import FoundationPlus

/// 단어 목록을 하나씩 넘기는 방식의 단어 암기 서비스입니다.
final class DefaultWordMemorizationService: WordMemorizationService {
    
    private(set) var wordList: [MemorizingWord]
    
    /// 현재 단어를 가리키는 Index.
    ///
    /// 배열이 비어있을 때는 `undefined` 값을 가집니다.
    private(set) var _currentIndex: Index
    
    var currentIndex: Int? {
        (_currentIndex == .undefined) ? nil : _currentIndex.rawValue
    }
    
    init() {
        self.wordList = []
        self._currentIndex = .undefined
    }
    
    var current: MemorizingWord? {
        guard _currentIndex != .undefined else { return nil }
        return wordList[_currentIndex.rawValue]
    }
    
    @discardableResult
    func next() -> MemorizingWord? {
        guard _currentIndex != .undefined else { return nil }
        
        wordList[_currentIndex.rawValue].isChecked = true
        
        if _currentIndex.rawValue < wordList.endIndex - 1 {
            _currentIndex.rawValue += 1
        } else {
            return nil
        }
        
        return current
    }
    
    @discardableResult
    func previous() -> MemorizingWord? {
        guard _currentIndex != .undefined else { return nil }
        
        if _currentIndex.rawValue == 0 {
            return nil
        }
        
        _currentIndex.rawValue -= 1
        
        return current
    }
    
    @discardableResult
    func shuffleList() -> MemorizingWord? {
        guard wordList.hasElements else { return nil }
        
        wordList.enumerated().forEach {
            wordList[$0.offset].isChecked = false
        }
        
        if count == 1 {
            _currentIndex.rawValue = 0
            return current
        }
        
        let oldCurrent = self.current
        _currentIndex.rawValue = 0
        repeat {
            wordList.shuffle()
        } while oldCurrent == self.current
        return current
    }
    
    func setList(_ list: [MemorizingWord], shuffled: Bool = true) {
        guard list.hasElements else {
            wordList = []
            _currentIndex = .undefined
            return
        }
        
        var list = list
        if shuffled {
            list.shuffle()
        }
        list.enumerated().forEach {
            list[$0.offset].isChecked = false
        }
        wordList = list
        _currentIndex = 0
    }
    
    var count: Int {
        wordList.count
    }
    
    var checkedCount: Int {
        wordList.filter({ $0.isChecked }).count
    }
    
    var unCheckedCount: Int {
        wordList.filter({ !$0.isChecked }).count
    }
    
    func deleteCurrent() {
        guard _currentIndex != .undefined else { return }
        
        wordList.remove(at: _currentIndex.rawValue)
        
        // 마지막 요소 지웠을 때 or 모든 요소 지웠을 때 index 처리
        if _currentIndex.rawValue == wordList.endIndex {
            _currentIndex.rawValue -= 1
        }
    }
    
    func deleteWord(by id: UUID) {
        guard let index = wordList.firstIndex(where: { $0.id == id }) else { return }
        
        wordList.remove(at: index)
        
        // [마지막 요소를 가리키고 있었을 때] or [모든 요소 지웠을 때] or [이미 지나온 단어 삭제 시] Index 처리
        if _currentIndex.rawValue == wordList.endIndex || index < _currentIndex.rawValue {
            _currentIndex.rawValue -= 1
        }
    }
    
    var isCompletedAllChecking: Bool {
        if unCheckedCount == 0 {
            return true
        } else {
            return false
        }
    }
    
    func appendWord(_ word: String, with id: UUID) throws {
        let word = try MemorizingWord(id: id, word: word, isChecked: false)
        
        // 목록이 비어있었다면 `currentIndex` 값 재설정 필요
        if wordList.isEmpty {
            _currentIndex.rawValue = 0
        }
        
        wordList.append(word)
    }
    
    func insertWord(_ word: String, with id: UUID) throws {
        let word = try MemorizingWord(id: id, word: word, isChecked: false)
        let validIndices = (_currentIndex.rawValue + 1)...(wordList.endIndex)
        let index = validIndices.randomElement()! // Always valid
        
        // 목록이 비어있었다면 `currentIndex` 값 재설정 필요
        if wordList.isEmpty {
            _currentIndex.rawValue = 0
        }
        
        wordList.insert(word, at: index)
    }
    
    func updateWord(to word: String, with id: UUID) {
        guard let index = wordList.firstIndex(where: { $0.id == id }) else { return }
        wordList[index].word = word
    }
}

struct Index: ExpressibleByIntegerLiteral, Equatable {
    
    var rawValue: Int
    
    init(integerLiteral value: Int) {
        rawValue = value
    }
    
    /// -1
    static let undefined: Self = -1
}
