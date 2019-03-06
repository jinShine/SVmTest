//
//  ServiceError.swift
//  SVmiOS
//
//  Created by 승진김 on 06/03/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import Foundation

enum ServiceError: Error {
    case unknown
    case requestFailed(Error)
}
