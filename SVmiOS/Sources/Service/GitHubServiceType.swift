//
//  GitHubServiceType.swift
//  SVmiOS
//
//  Created by 승진김 on 06/03/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import RxSwift

protocol GitHubServiceType {
    func requestGitHubAllUser(since: Int) -> Single<[UserModel]>
}
