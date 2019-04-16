//
//  RealmHelper.swift
//  GitUsers
//
//  Created by Rufat A.A. on 4/16/19.
//  Copyright © 2019 Rufat A.A. All rights reserved.
//

import Foundation
import RealmSwift

struct RealmHelper
{
    let realm = try! Realm()
    
    private init() {}
    
    public static let shared = RealmHelper()
    
    public func loadUsers() -> [User] {
        return Array(realm.objects(User.self))
    }
    
    public func addNewUser(repo: User) {
        try! realm.write {
            realm.add(repo)
        }
    }
    
    public func clearAllUsers() {
        try! realm.write {
            realm.delete(realm.objects(User.self))
        }
    }
}
