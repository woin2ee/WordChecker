//
//  WordUseCaseTests.swift
//  WordUseCaseTests
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Domain
import XCTest

final class WordUseCaseTests: XCTestCase {

    var sut: WordUseCaseProtocol!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let wordRepository: WordRepositoryProtocol = WordRepositoryStub()
        sut = WordUseCase.init(wordRepository: wordRepository)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func test() {

    }

}
