//
//  UserRepositoryModel.swift
//  SVmiOS
//
//  Created by 승진김 on 07/03/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import Foundation

//name, description, stargazers_count, watchers_count, created_at 값을 표시해주세요.)

struct UserRepositoryModel: Decodable {
    var id: Int
    var name: String
    var description: String?
    var stargazersCount: Int
    var watchersCount: Int
    var createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, description
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case createdAt = "created_at"
    }
    
    init() {
        id = 0
        name = ""
        description = ""
        stargazersCount = 0
        watchersCount = 0
        createdAt = ""
    }
}
