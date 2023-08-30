//
//  RealmError.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/25.
//

import Foundation
import Realm
import RealmSwift

enum RealmError: Error {

    case notMatchedObjectID(type: Object.Type, objectID: ObjectId)

}
