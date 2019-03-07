//
//  UserDetailModel.swift
//  SVmiOS
//
//  Created by 승진김 on 07/03/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import Foundation

struct UserDetailModel: Decodable {
    var id: Int
    var login: String
    var profile: String?
    var name: String
    var location: String?
    var company: String?
    var followers: Int
    var following: Int
    
    enum CodingKeys: String, CodingKey {
        case id, login, name, location, company, followers, following
        case profile = "avatar_url"
    }
    
    init() {
        id = 0
        login = ""
        profile = ""
        name = ""
        location = ""
        company = ""
        followers = 0
        following = 0
    }
}
