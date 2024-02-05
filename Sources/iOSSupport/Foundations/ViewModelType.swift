//
//  ViewModelType.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/11.
//

public protocol ViewModelType {

    associatedtype Input

    associatedtype Output

    func transform(input: Input) -> Output

}
