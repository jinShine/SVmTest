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
    
    // RX
    func requestGitHubAllUser(since: Int) -> Single<[UserModel]> {
        return Router.buildRequest(url: Router.allUser(since: since))
            .map { data throws in
                let users = try JSONDecoder().decode([UserModel].self, from: data)
                return users
            }
    }
    
    // Swift
    func requestGitHubUserDetail(name: String, completion: @escaping (Result<UserDetailModel>) -> ()) {
        Alamofire.request(Router.userDetail(name: name))
            .validate(statusCode: 200..<400)
            .responseData { response in
                switch response.result {
                case .success(let value):
                    do {
                        let result = try JSONDecoder().decode(UserDetailModel.self, from: value)
                        print(result)
                        completion(Result.success(result))
                    } catch {
                        completion(Result.failure(ServiceError.decodeError))
                    }
                case .failure(let error):
                    completion(Result.failure(ServiceError.requestFailed(error)))
                }
        }
    }
    
    func requestGitHubUserRepositories(name: String, page: Int, completion: @escaping (Result<[UserRepositoryModel]>) -> ()) {
        Alamofire.request(Router.userRepo(name: name, page: page))
            .validate(statusCode: 200..<400)
            .responseData { response in
                switch response.result {
                case .success(let value):
                    do {
                        let result = try JSONDecoder().decode([UserRepositoryModel].self, from: value)
                        print(result)
                        completion(Result.success(result))
                    } catch {
                        completion(Result.failure(ServiceError.decodeError))
                    }
                case .failure(let error):
                    completion(Result.failure(ServiceError.requestFailed(error)))
                }
        }
    }
}

