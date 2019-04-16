//
//  JSONHelper.swift
//  GitUsers
//
//  Created by Rufat A.A. on 4/16/19.
//  Copyright © 2019 Rufat A.A. All rights reserved.
//

import Foundation
import SwiftyJSON

struct JSONHelper {
    
    /// Decodes JSON file into the list of Users
    ///
    /// - Parameter rawValue: raw data in JSON format
    /// - Returns: the list of Users
    func decode(from rawValue: Data) -> [User] {
        let json = JSON(rawValue)
        var users: [User] = []
        
        guard let items = json.array else {
            print("Invalid JSON array")
            return users
        }
        
        for item in items {
            guard let id = item["id"].int32 else{
                print("Failed to parse JSON")
                return users
            }
            
            guard let login = item["login"].string else {
                print("Failed to parse JSON")
                return users
            }
            
            let user = User()
            user.id = id
            user.login = login
            
            users.append(user)
        }
        
        return users
    }
}
