//
//  APIProtocol.swift
//  GitUsers
//
//  Created by Rufat A.A. on 4/17/19.
//  Copyright © 2019 Rufat A.A. All rights reserved.
//

import Foundation

protocol APIProtocol {
    func fetchUsers(usersPerPage perPage: Int, LastId since: Int, completion callback: @escaping ((_ repos: [User], _ error: String?) -> Void))
}
