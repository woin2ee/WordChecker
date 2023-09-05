//
//  CircularLinkedList.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/24.
//

import Foundation

struct CircularLinkedList<Element: Equatable> {

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

    init(_ sequence: some Sequence<Element>) {
        self.elements = .init(sequence)
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

    mutating func previous() -> Element? {
        guard count > 1 else {
            return elements.first
        }
        currentIndex -= 1
        if currentIndex < 0 {
            currentIndex = count - 1
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

    mutating func deleteCurrent() {
        guard count > 0 else { return }
        elements.remove(at: currentIndex)
        if currentIndex >= count {
            currentIndex = 0
        }
    }

    mutating func delete(_ object: Element) {
        guard let targetIndex = elements.firstIndex(where: { $0 == object }) else {
            return
        }
        elements.remove(at: targetIndex)
        if currentIndex >= count {
            currentIndex = 0
        }
    }

    func first(where predicate: (Element) throws -> Bool) -> Element? {
        guard count > 0 else { return nil }
        return try? elements.first(where: predicate)
    }

}
