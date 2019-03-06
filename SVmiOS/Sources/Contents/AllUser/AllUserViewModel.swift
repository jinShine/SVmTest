//
//  AllUserViewModel.swift
//  SVmiOS
//
//  Created by 승진김 on 06/03/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

typealias AllUserData = SectionModel<String, UserModel>

protocol AllUserViewModelType: ViewModelType {
    
    // Event
    
    var viewWillAppear: PublishSubject<Void> { get }
    
    
    // UI
    var allUserArray: Driver<[AllUserData]> { get }
    
}

final class AllUserViewModel: AllUserViewModelType {
    
    //MARK:- Properties
    //MARK: -> Event
    
    let viewWillAppear = PublishSubject<Void>()
    
    
    //MARK: <- UI
    
    let allUserArray: Driver<[AllUserData]>
    
    
    
    
    
    
    //MARK:- Initialize
    init(gitHubService: GitHubServiceType) {
        allUserArray = Observable<Void>
            .merge([viewWillAppear])
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .flatMapLatest {
                return gitHubService.requestGitHubAllUser(since: 3)
            }
            .map { [AllUserData(model: "", items: $0)] }
            .asDriver(onErrorJustReturn: [])
    }
    
}
