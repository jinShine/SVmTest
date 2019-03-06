//
//  GitHubService.swift
//  SVmiOS
//
//  Created by 승진김 on 06/03/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import RxCocoa
import RxSwift
import Alamofire

struct GitHubService: GitHubServiceType {
    
    func requestGitHubAllUser(since: Int) -> Single<[UserModel]> {
        return Router.buildRequest(url: Router.getAllUser(since: since))
            .map { data throws in
                let users = try JSONDecoder().decode([UserModel].self, from: data)
                return users
            }
    }
}

