//
//  WCUserDefaults+Rx.swift
//  Data
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import RxSwift
import RxUtility

extension WCUserDefaults: ReactiveCompatible {}

extension Reactive where Base: WCUserDefaults {

    func setValue(_ value: Any?, forKey key: UserDefaultsKey) -> Single<Void> {
        base.setValue(value, forKey: key)

        return .just(())
    }

    func setCodable(_ value: Codable, forKey key: UserDefaultsKey) -> Single<Void> {
        let result = base.setCodable(value, forKey: key)

        switch result {
        case .success:
            return .just(())
        case .failure(let error):
            return .error(error)
        }
    }

    func object(forKey key: UserDefaultsKey) -> Single<Any> {
        let object = base.object(forKey: key)

        guard let object = object else {
            return .error(UserDefaultsError.keyNotFound)
        }

        return .just(object)
    }

    func object<T: Decodable>(_ type: T.Type, forKey key: UserDefaultsKey) -> Single<T> {
        let result = base.object(type, forKey: key)

        switch result {
        case .success(let decoded):
            return .just(decoded)
        case .failure(let error):
            return .error(error)
        }
    }

}
