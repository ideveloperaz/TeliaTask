//
//  UsersManager.swift
//  GitUsers
//
//  Created by Rufat A.A. on 4/16/19.
//  Copyright © 2019 Rufat A.A. All rights reserved.
//

import Foundation
import RealmSwift

/// MARK: - struct that manages all data
class UsersManager: EntitiesManagerProtocol {    
    static var isLoading = false
    private let apiClient: APIProtocol
    private let storageHelper: StorageProtocol
    private let usersPerPage = 50
    private var lastId = 0;
    
    private init(ApiClient: APIProtocol, StorageClient: StorageProtocol) {
        apiClient = ApiClient
        storageHelper = StorageClient
    }
    
    public static let shared = UsersManager(ApiClient: GithubAPIHelper.shared, StorageClient: RealmHelper.shared)
    
    public func reload()
    {
        lastId = 0
    }
    
    public func loadItems(online: Bool, completion callback: @escaping ((_ repos: [Object]) -> Void)) {
        if UsersManager.isLoading {
            return
        }
        
        UsersManager.isLoading = true
        
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
                    self.storageHelper.clearAllUsers()
                }
                
                for user in users {
                    self.storageHelper.addNewUser(user: user)
                }
                
                callback(users)
                
                if let lastUser = users.last {
                    self.lastId = Int(lastUser.id)
                }
                
                UsersManager.isLoading = false
            })
        } else {
            // Load local data
            let users = storageHelper.loadUsers()
            UsersManager.isLoading = false

            if users.count == 0 {
                // No local data available. Need to load from remote source.
                loadItems(online: true, completion: callback)
            } else {
                if let lastUser = users.last {
                    self.lastId = Int(lastUser.id)
                }
                callback(storageHelper.loadUsers())
            }
        }
    }
}
