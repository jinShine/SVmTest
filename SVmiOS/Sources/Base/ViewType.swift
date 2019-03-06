//
//  ViewType.swift
//  SVmiOS
//
//  Created by 승진김 on 06/03/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import UIKit
import RxSwift

protocol ViewType: class {
    associatedtype ViewModelType
    var viewModel: ViewModelType! { get set }
    var disposeBag: DisposeBag! { get set }
    func setupUI()
    func setupEventBinding()
    func setupUIBinding()
}

extension ViewType where Self: UIViewController {
    static func create(with viewModel: ViewModelType) -> Self {
        let `self` = Self()
        self.viewModel = viewModel
        self.disposeBag = DisposeBag()
        self.loadViewIfNeeded()
        self.setupUI()
        self.setupEventBinding()
        self.setupUIBinding()
        return self
    }
}
