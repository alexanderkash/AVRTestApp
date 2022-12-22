//
//  RealmStorageManager.swift
//  ARVTestApp
//
//  Created by Alexander Kogalovsky on 22.12.22.
//

import Foundation
import RealmSwift

final class RealmStorageService {
    
    private var realm: Realm = {
        return try! Realm()
    }()
    
    static let shared = RealmStorageService()
    
    private init() {}
    
    func update(object: Object) {
        try? realm.write {
            realm.add(object, update: .modified)
        }
    }
    
    func object(byId id: String, type: Object.Type) -> Object? {
        return realm.object(ofType: type, forPrimaryKey: id)
    }
}

enum RealmStorageError: Error {
    case retrievingError
}
