//
//  ReducerType.swift
//  StateStore
//
//  Created by Jaewon Yun on 2023/09/05.
//

import ReSwift

public protocol ReducerType {

    associatedtype State: StateType

    func createNewState(action: Action, state: State?) -> State

}
