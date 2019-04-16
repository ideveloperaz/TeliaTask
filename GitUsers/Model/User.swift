//
//  User.swift
//  GitUsers
//
//  Created by Rufat A.A. on 4/16/19.
//  Copyright © 2019 Rufat A.A. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object
{
    @objc dynamic var id: Int32 = -1
    @objc dynamic var login: String = ""
    
    override func isEqual(_ object: Any?) -> Bool {
        guard object is User else {
            return false
        }
        
        let user = object as! User
        
        return user.id == self.id && user.login == self.login
    }
}
