//
//  EntitiesManagerProtocol.swift
//  GitUsers
//
//  Created by Rufat A.A. on 4/17/19.
//  Copyright © 2019 Rufat A.A. All rights reserved.
//

import Foundation
import RealmSwift

protocol EntitiesManagerProtocol {
    func reload()
    func loadItems(online: Bool, completion callback: @escaping ((_ repos: [Object]) -> Void))
}
