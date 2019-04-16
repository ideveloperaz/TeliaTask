//
//  UsersManager.swift
//  GitUsers
//
//  Created by Rufat A.A. on 4/16/19.
//  Copyright © 2019 Rufat A.A. All rights reserved.
//

import Foundation

/// MARK: - struct that manages all data
class UsersManager {
    private let apiClient = GithubAPIHelper.shared
    private let realmHelper = RealmHelper.shared
    private let usersPerPage = 50
    private var lastId = 0;
    
    private init() {}
    
    public static let shared = UsersManager()
    
    public func reload()
    {
        lastId = 0
    }
    
    public func loadUsers(online: Bool, completion callback: @escaping ((_ repos: [User]) -> Void)) {
        if online {
            // Force to load remote data source.
            apiClient.fetchUsers(usersPerPage: usersPerPage, LastId: lastId,  completion: {
                users, error in
                
                guard error == nil else {
                    print("Something went wrong when fetching users: \(String(describing: error))")
                    return
                }
                
                // Clear old data and save new data into realm database.
                if self.lastId == 0 {
                    self.realmHelper.clearAllUsers()
                }
                
                for user in users {
                    self.realmHelper.addNewUser(user: user)
                }
                
                callback(users)
                
                self.lastId = self.lastId + self.usersPerPage
            })
        } else {
            // Load local data
            let users = realmHelper.loadUsers()
            
            if users.count == 0 {
                // No local data available. Need to load from remote source.
                loadUsers(online: true, completion: callback)
            } else {
                self.lastId = users.count
                callback(realmHelper.loadUsers())
            }
        }
    }
}
