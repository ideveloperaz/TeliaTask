//
//  UsersManager.swift
//  GitUsers
//
//  Created by Rufat A.A. on 4/16/19.
//  Copyright © 2019 Rufat A.A. All rights reserved.
//

import Foundation

/// MARK: - struct that manages all data
struct UsersManager {
    private let apiClient = GithubAPIHelper.shared
    private let realmHelper = RealmHelper.shared
    
    private init() {}
    
    public static let shared = UsersManager()
    
    public func loadUsers(online: Bool, completion callback: @escaping ((_ repos: [User]) -> Void)) {
        if online {
            // Force to load remote data source.
            apiClient.fetchUsers(completion: {
                users, error in
                
                guard error == nil else {
                    print("Something went wrong when fetching users: \(String(describing: error))")
                    return
                }
                
                // Clear old data and save new data into realm database.
                self.realmHelper.clearAllUsers()
                
                for repo in users {
                    self.realmHelper.addNewUser(repo: repo)
                }
                
                callback(users)
            })
        } else {
            // Load local data
            let repos = realmHelper.loadUsers()
            
            if repos.count == 0 {
                // No local data available. Need to load from remote source.
                loadUsers(online: true, completion: callback)
            } else {
                callback(realmHelper.loadUsers())
            }
        }
    }
}
