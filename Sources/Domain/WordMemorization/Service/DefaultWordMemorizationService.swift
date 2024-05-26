import Foundation
import FoundationPlus

/// 단어 목록을 하나씩 넘기는 방식의 단어 암기 서비스입니다.
final class DefaultWordMemorizationService: WordMemorizationService {
    
    private(set) var wordList: [Word]
    
    /// 현재 단어를 가리키는 Index.
    ///
    /// 배열이 비어있을 때는 `undefined`, 모든 단어를 확인했을 때는 단어들의 갯수(`count`)와 같은 값을 가집니다.
    private(set) var currentIndex: Index
    
    init() {
        self.wordList = []
        self.currentIndex = .undefined
    }
    
    var current: Word? {
        guard currentIndex != .undefined else { return nil }
        if self.isCompletedAllChecking {
            return wordList.last
        }
        return wordList[currentIndex.rawValue]
    }
    
    @discardableResult
    func next() -> Word? {
        guard currentIndex != .undefined else { return nil }
        
        wordList[currentIndex.rawValue].isChecked = true
        
        if currentIndex.rawValue < wordList.count {
            currentIndex.rawValue += 1
        }
        
        guard currentIndex.rawValue < wordList.count else {
            return nil
        }
        
        return current
    }
    
    @discardableResult
    func previous() -> Word? {
        guard currentIndex != .undefined else { return nil }
        
        if currentIndex.rawValue == 0 {
            return nil
        }
        
        currentIndex.rawValue -= 1
        
        return current
    }
    
    @discardableResult
    func shuffleList() -> Word? {
        wordList.enumerated().forEach {
            wordList[$0.offset].isChecked = false
        }
        
        guard count > 1 else { return current }
        
        let oldCurrent = self.current
        repeat {
            wordList.shuffle()
        } while oldCurrent == self.current
        return current
    }
    
    func setList(_ list: [Word], shuffled: Bool = true) {
        guard list.hasElements else {
            wordList = []
            currentIndex = .undefined
            return
        }
        
        var list = list
        if shuffled {
            list.shuffle()
        }
        wordList = list
        currentIndex = 0
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
        guard currentIndex != .undefined else { return }
        
        if self.isCompletedAllChecking {
            currentIndex.rawValue -= 1
        }
        
        wordList.remove(at: currentIndex.rawValue)
        
        if wordList.count == 0 {
            currentIndex = .undefined
        }
    }
    
    var isCompletedAllChecking: Bool {
        if currentIndex.rawValue == wordList.count {
            return true
        } else {
            return false
        }
    }
}

struct Index: ExpressibleByIntegerLiteral, Equatable {
    
    var rawValue: Int
    
    init(integerLiteral value: Int) {
        rawValue = value
    }
    
    static let undefined: Self = -1
}
