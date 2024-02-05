//
//  AllCases+index.swift
//  iOSSupport
//
//  Created by Jaewon Yun on 2/5/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Foundation

extension Array where Element: CaseIterable & Equatable {

    /// AllCases 배열에서 주어진 열거형 값에 해당하는 index 를 반환합니다.
    /// - Parameter element: 열거형 값
    /// - Returns: 주어진 열거형 값에 해당하는 index
    public func index(of element: Element) -> Int {
        guard let index = self.firstIndex(of: element) else {
            fatalError("This method was used where it was not appropriate.")
        }
        return index
    }

}
