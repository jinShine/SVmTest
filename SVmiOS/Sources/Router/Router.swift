//
//  Router.swift
//  SVmiOS
//
//  Created by 승진김 on 06/03/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import RxSwift
import Alamofire


/*
 1. 모든 User 목록 https://developer.github.com/v3/users/#get-all-users
 2. 특정 사용자의 기본 정보 https://developer.github.com/v3/users/#get-a-single-user
 3. 특정 사용자가 보유한 Repository(public 권한) 목록 https://developer.github.com/v3/repos/#list-user-repositories (‘page’ 로 페이징을 합니다.)
 */

enum Router {
    case allUser(since: Int)
    case userDetail(name: String)
    case userRepo(name: String, page: Int)
}

extension Router: TargetType {
    
    // GitHub Key
    static let clientID: String = "075f9bae947051708b29"
    static let clientSecret: String = "e5593a561341875f9a5a768bca8d74b398aff81e"
    
    
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .allUser:
            return "/users"
        case .userDetail(let name):
            return "/users/\(name)"
        case .userRepo(let name, _):
            return "/users/\(name)/repos"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .allUser, .userDetail, .userRepo:
            return .get
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .allUser, .userDetail, .userRepo:
            return [:]
        }
    }
    
    var parameter: Parameters {
        switch self {
        case .allUser(let since):
            return [
                "since" : since,
                "client_id" : Router.clientID,
                "client_secret" : Router.clientSecret
            ]
        case .userDetail:
            return [:]
        case .userRepo(_, let page):
            return [
                "page" : page
            ]
        }
    }
}

// Rx Alamofire Request
extension Router {
    
    static let manager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        configuration.httpCookieStorage = HTTPCookieStorage.shared
        configuration.urlCache = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }()
    
    static func buildRequest(url: URLRequestConvertible) -> Single<Data> {
        return Single.create(subscribe: { (observer) -> Disposable in
            Router.manager.request(url)
                .validate(statusCode: 200..<400)
                .responseData(completionHandler: { data in
                    switch data.result {
                    case .success(let value):
                        observer(.success(value))
                    case .failure(let error):
                        observer(.error(ServiceError.requestFailed(error)))
                    }
                })
            return Disposables.create()
        })
    }
}

extension Router: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        switch self {
        case .allUser, .userDetail, .userRepo:
            let url = self.baseURL.appendingPathComponent(self.path)
            var urlRequest = try URLRequest(url: url, method: self.method, headers: self.header)
            urlRequest = try URLEncoding.default.encode(urlRequest, with: self.parameter)
            print("Router .\(self) URL : ",urlRequest)
            return urlRequest
        }
    }
}
