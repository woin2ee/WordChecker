//
//  StateType.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/05.
//

import ReSwift

public protocol StateType {

    associatedtype Reducer: ReducerType

    associatedtype Actions: Action

}
