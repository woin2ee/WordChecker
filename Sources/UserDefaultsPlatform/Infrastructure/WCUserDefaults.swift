//
//  WCUserDefaults.swift
//  Data
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation

public final class WCUserDefaults {

    private let _userDefaults: UserDefaults

    public init(_userDefaults: UserDefaults) {
        self._userDefaults = _userDefaults
    }

    func setValue(_ value: Any?, forKey key: UserDefaultsKey) {
        _userDefaults.setValue(value, forKey: key.rawValue)
    }

    func setCodable(_ value: Codable, forKey key: UserDefaultsKey) -> Result<Void, Error> {
        do {
            let encoded = try JSONEncoder().encode(value)
            setValue(encoded, forKey: key)

            return .success(())
        } catch {
            return .failure(error)
        }
    }

    func object(forKey key: UserDefaultsKey) -> Any? {
        return _userDefaults.object(forKey: key.rawValue)
    }

    func object<T: Decodable>(_ type: T.Type, forKey key: UserDefaultsKey) -> Result<T, Error> {
        let object = self.object(forKey: key)

        guard let data = object as? Data else {
            return .failure(UserDefaultsError.keyNotFound)
        }

        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(error)
        }
    }

}
