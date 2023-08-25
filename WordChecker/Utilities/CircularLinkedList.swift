//
//  CircularLinkedList.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/24.
//

import Foundation

struct CircularLinkedList<Element> {
    
    private var elements: [Element] = []
    
    private var currentIndex: Int = 0
    
    var count: Int {
        elements.count
    }
    
    var current: Element? {
        guard count > 1 else {
            return elements.first
        }
        return elements[currentIndex]
    }
    
    init() {}
    
    init(_ s: some Sequence<Element>) {
        self.elements = .init(s)
    }
    
    mutating func next() -> Element? {
        guard count > 1 else {
            return elements.first
        }
        currentIndex += 1
        if currentIndex >= count {
            currentIndex = 0
        }
        return current
    }
    
    mutating func append(_ newElement: Element) {
        elements.append(newElement)
    }
    
    /// 연결되어있는 요소들을 섞고 현재 가리키고 있는 요소를 재설정합니다.
    mutating func shuffle() {
        elements.shuffle()
        currentIndex = 0
    }
    
}
