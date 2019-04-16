//
//  GithubAPIHelper.swift
//  GitUsers
//
//  Created by Rufat A.A. on 4/16/19.
//  Copyright © 2019 Rufat A.A. All rights reserved.
//

import Foundation
import Alamofire

struct GithubAPIHelper {
    let HOST = "https://api.github.com/"
    let USERS_ENDPOINT = "users"
    
    let parser = JSONHelper()
    
    private init(){}
    
    public static let shared = GithubAPIHelper()
    
    /// Fetches all users written in Swift
    public func fetchUsers(completion callback: @escaping ((_ repos: [User], _ error: String?) -> Void)) {
        var error: String?
        var users: [User] = []
        
        let urlStr = HOST + USERS_ENDPOINT
        
        let parameters: Parameters = [
            "per_page":"10",
            "since":"0"
        ]
        
        Alamofire.request(urlStr, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: {
                response in
                // Guarantee that we get response with the HTTP status code 200.
                guard response.response?.statusCode == 200 else {
                    error = "Failed to fetch data: \(String(describing: response.response?.statusCode))"
                    callback(users, error)
                    return
                }
                
                error = response.error?.localizedDescription
                
                if let data = response.data {
                    users = self.parser.decode(from: data)
                }
                
                callback(users, error)
            })
    }
}
