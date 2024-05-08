//
//  RxBaseTestCase.swift
//  iOSCoreUnitTests
//
//  Created by Jaewon Yun on 2023/10/05.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import RxSwift
import RxTest
import XCTest

open class RxBaseTestCase: XCTestCase {

    public var disposeBag: DisposeBag!
    public var testScheduler: TestScheduler!

    open override func setUpWithError() throws {
        try super.setUpWithError()
        disposeBag = .init()
        testScheduler = .init(initialClock: 0)
    }

    open override func tearDownWithError() throws {
        try super.tearDownWithError()
        disposeBag = nil
        testScheduler = nil
    }
}
