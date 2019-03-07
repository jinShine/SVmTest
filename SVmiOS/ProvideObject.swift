//
//  ProvideObject.swift
//  SVmiOS
//
//  Created by 승진김 on 06/03/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import RxSwift
import RxCocoa

enum ProvideObject {
    case allUser
    case userRepositories(name: String)
}

extension ProvideObject {
    var viewController: UIViewController {
        switch self {
        case .allUser:
            let viewModel = AllUserViewModel(gitHubService: GitHubService())
            let viewController = AllUserViewController.create(with: viewModel)
            return viewController
            
        case .userRepositories(let name):
            let viewController = UserRepositoriesViewController(userName: name, gitHubService: GitHubService())
            return viewController
        }
    }
}
