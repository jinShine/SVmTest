//
//  Rx+Alamofire.swift
//  SVmiOS
//
//  Created by 승진김 on 06/03/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import RxCocoa
import RxSwift
import Alamofire

extension Reactive where Base: SessionManager {
    func request(url: URLRequestConvertible) -> Single<Data> {
        return Single.create(subscribe: { (observer) -> Disposable in
            self.base.request(url)
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
