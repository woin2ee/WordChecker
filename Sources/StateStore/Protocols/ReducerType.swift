//
//  ReducerType.swift
//  StateStore
//
//  Created by Jaewon Yun on 2023/09/05.
//

import Foundation
import ReSwift

protocol ReducerType {

    associatedtype State

    func createNewState(action: Action, state: State?) -> State

}
