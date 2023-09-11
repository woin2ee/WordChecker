//
//  ViewModelType.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/11.
//

protocol ViewModelType {

    associatedtype Input

    associatedtype Output

    func transform(input: Input) -> Output

}
