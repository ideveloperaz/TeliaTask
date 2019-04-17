//
//  UsersViewModel.swift
//  GitUsers
//
//  Created by Rufat A.A. on 4/16/19.
//  Copyright © 2019 Rufat A.A. All rights reserved.
//

import Foundation
import RxSwift

class UsersViewModel {
    let usersManager: EntitiesManagerProtocol
    var users = Variable<[User]>([])
    var usersCache: [User] = []
    
    init(manager: EntitiesManagerProtocol) {
        usersManager = manager
        // Load users
        loadUsers(online: false)
    }
    
    // Load users
    func loadUsers(online: Bool) {
        self.usersManager.reload();
        
        self.usersManager.loadItems(online: online, completion: {
            result in
            self.users.value = result as! [User]
            self.usersCache = result as! [User]
        })
    }

    // willDisplayCell use it to load next portion of data when last cell reached
    func showingUserByIndex(userIndex index: Int) {
        if usersCache.count == index + 1 {
            self.usersManager.loadItems(online: true, completion: {
                result in
                self.users.value.append(contentsOf: result as! [User])
                self.usersCache.append(contentsOf: result as! [User])
            })
        }
    }
}
