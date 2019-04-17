//
//  RealmHelper.swift
//  GitUsers
//
//  Created by Rufat A.A. on 4/16/19.
//  Copyright © 2019 Rufat A.A. All rights reserved.
//

import Foundation
import RealmSwift

struct RealmHelper: StorageProtocol
{
    let realm = try! Realm()
    
    private init() {}
    
    public static let shared = RealmHelper()
    
    // Loads users from realm
    public func loadUsers() -> [User] {
        return Array(realm.objects(User.self).sorted(byKeyPath: "id"))
    }
    
    // Add new user to realm
    public func addNewUser(user: User) {
        try! realm.write {
            realm.add(user)
        }
    }
    
    // Removes all users from realm
    public func clearAllUsers() {
        try! realm.write {
            realm.delete(realm.objects(User.self))
        }
    }
}
