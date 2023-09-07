//
//  CircularLinkedList.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/24.
//

import Foundation

public struct CircularLinkedList<Element> {

    public private(set) var elements: [Element] = []

    public private(set) var currentIndex: Int = 0

    public var count: Int {
        elements.count
    }

    public var current: Element? {
        guard count > 1 else {
            return elements.first
        }
        return elements[currentIndex]
    }

    public init() {}

    public init(_ sequence: some Sequence<Element>) {
        self.elements = .init(sequence)
    }

    @discardableResult
    public mutating func next() -> Element? {
        guard count > 1 else {
            return elements.first
        }
        currentIndex += 1
        if currentIndex >= count {
            currentIndex = 0
        }
        return current
    }

    @discardableResult
    public mutating func previous() -> Element? {
        guard count > 1 else {
            return elements.first
        }
        currentIndex -= 1
        if currentIndex < 0 {
            currentIndex = count - 1
        }
        return current
    }

    public mutating func append(_ newElement: Element) {
        elements.append(newElement)
    }

    /// 연결되어있는 요소들을 섞고 현재 가리키고 있는 요소를 재설정합니다.
    public mutating func shuffle() {
        elements.shuffle()
        currentIndex = 0
    }

    public mutating func deleteCurrent() {
        guard count > 0 else { return }
        elements.remove(at: currentIndex)
        if currentIndex >= count {
            currentIndex = 0
        }
    }

    public mutating func delete(at index: Int) {
        guard index < elements.count else {
            assertionFailure("Out of index.")
            return
        }
        elements.remove(at: index)
        if currentIndex >= count {
            currentIndex = 0
        }
    }

    public func first(where predicate: (Element) throws -> Bool) -> Element? {
        guard count > 0 else { return nil }
        return try? elements.first(where: predicate)
    }

    public func firstIndex(where predicate: (Element) throws -> Bool) -> Int? {
        guard count > 0 else { return nil }
        return try? elements.firstIndex(where: predicate)
    }

    public mutating func replace(at index: Int, to element: Element) {
        guard index < elements.count else {
            assertionFailure("Out of index.")
            return
        }
        elements[index] = element
    }

}
