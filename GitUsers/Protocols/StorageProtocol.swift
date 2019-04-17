//
//  StorageProtocol.swift
//  GitUsers
//
//  Created by Rufat A.A. on 4/17/19.
//  Copyright © 2019 Rufat A.A. All rights reserved.
//

import Foundation

protocol StorageProtocol {
    func loadUsers() -> [User]
    func addNewUser(user: User)
    func clearAllUsers()
}
