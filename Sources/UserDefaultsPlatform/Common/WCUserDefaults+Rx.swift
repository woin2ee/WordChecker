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

    /// Creates a single sequence with set value from a subscribe method implementation.
    /// - Parameters:
    ///   - value: The value for the property identified by key.
    ///   - key: The name of one of the receiver's properties.
    /// - Returns: A object that did set.
    func setValue(_ value: Any?, forKey key: Base.UserDefaultsKey) -> Single<Any> {
        return .create { result in
            base.setValue(value, forKey: key)

            if let object = base.object(forKey: key) {
                result(.success(object))
            } else {
                result(.failure(UserDefaultsError.keyNotFound))
            }

            return Disposables.create()
        }
    }

    func setCodable(_ value: Codable, forKey key: Base.UserDefaultsKey) -> Single<Void> {
        do {
            let encoded = try JSONEncoder().encode(value)

            return setValue(encoded, forKey: key)
                .mapToVoid()
        } catch {
            return .error(error)
        }
    }

    func object(forKey key: Base.UserDefaultsKey) -> Single<Any> {
        return .create { result in
            if let object = base.object(forKey: key) {
                result(.success(object))
            } else {
                result(.failure(UserDefaultsError.keyNotFound))
            }

            return Disposables.create()
        }
    }

    func object<T: Decodable>(_ type: T.Type, forKey key: Base.UserDefaultsKey) -> Single<T> {
        return object(forKey: key)
            .map { $0 as? Data }
            .unwrapOrThrow()
            .map { decodableObject in
                return try JSONDecoder().decode(type, from: decodableObject)
            }
    }

    enum UserDefaultsError: Error {

        case keyNotFound

    }

}
