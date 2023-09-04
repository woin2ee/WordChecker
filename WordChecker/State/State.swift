//
//  State.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/04.
//

import ReSwift

protocol State {

    static func reducer(action: Action, state: Self?) -> Self

    static func initialState(action: Action, state: Self?) -> Self

}
