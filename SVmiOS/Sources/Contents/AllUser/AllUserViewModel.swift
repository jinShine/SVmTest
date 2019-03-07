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
    var didPullToRefresh: PublishSubject<Void> { get }
    var willDisplayCell: PublishSubject<(cell: UITableViewCell, indexPath: IndexPath)> { get }
    var didCellSelected: PublishSubject<UserModel> { get }
    
    
    // UI
    var allUserArray: Driver<[AllUserData]> { get }
    var isRefreshing: Driver<Bool> { get }
//    var loadMore: Driver<[AllUserData]> { get }
    var showUserRepositories: Driver<String> { get }
    
}

final class AllUserViewModel: AllUserViewModelType {
    
    //MARK:- Properties
    //MARK: -> Event
    
    let viewWillAppear = PublishSubject<Void>()
    let didPullToRefresh = PublishSubject<Void>()
    let willDisplayCell = PublishSubject<(cell: UITableViewCell, indexPath: IndexPath)>()
    let didCellSelected = PublishSubject<UserModel>()
    
    //MARK: <- UI
    
    var allUserArray: Driver<[AllUserData]>
    let isRefreshing: Driver<Bool>
//    let loadMore: Driver<[AllUserData]>
    let showUserRepositories: Driver<String>
    
    
    
    //MARK:- Initialize
    init(gitHubService: GitHubServiceType) {
        
        let onRefreshing = PublishSubject<Bool>()
        isRefreshing = onRefreshing.asDriver(onErrorJustReturn: false)
        
        var loadMoreCount: Int = 0
        
        allUserArray = Observable<Void>
            .merge([viewWillAppear, didPullToRefresh])
            .do { onRefreshing.onNext(true) }
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .flatMapLatest {
                return gitHubService.requestGitHubAllUser(since: loadMoreCount)
                    .retry(2)
                    .do { onRefreshing.onNext(false) }
            }
            .map { [AllUserData(model: "", items: $0)] }
            .asDriver(onErrorJustReturn: [])
        
        
         showUserRepositories = didCellSelected
            .map { $0.name }
            .asDriver(onErrorJustReturn: "")
        
//        allUserArray = willDisplayCell
//            .map { ($0, $1) }
//            .filter { (_, indexPath) -> Bool in
//                guard loadMoreCount != 0 else { return false }
//                print("IIIIINNNNDDDEEEEPPPAATH", indexPath)
//                if indexPath.row == loadMoreCount {
//                    loadMoreCount += 45
//                    return true
//                }
//                return false
//            }
//            .do { onRefreshing.onNext(true) }
//            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
//            .flatMapLatest { _ in
//                return gitHubService.requestGitHubAllUser(since: loadMoreCount)
//                    .retry(2)
//                    .do { onRefreshing.onNext(false) }
//            }
//            .map { [AllUserData(model: "", items: $0)] }
//            .asDriver(onErrorJustReturn: [])

    }
    
}
