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
    var showUserRepositories: Driver<String> { get }
    var requestAllUserData: Driver<Void> { get }
    var requestLoadMore: Driver<Void> { get }
    
}

final class AllUserViewModel: AllUserViewModelType {
    
    private struct Constant {
        static let repositoriesCountPerPage: Int = 30
    }
    
    //MARK:- Properties
    //MARK: -> Event
    
    let viewWillAppear = PublishSubject<Void>()
    let didPullToRefresh = PublishSubject<Void>()
    let willDisplayCell = PublishSubject<(cell: UITableViewCell, indexPath: IndexPath)>()
    let didCellSelected = PublishSubject<UserModel>()
    
    //MARK: <- UI
    
    var allUserArray: Driver<[AllUserData]>
    let isRefreshing: Driver<Bool>
    let showUserRepositories: Driver<String>
    let requestAllUserData: Driver<Void>
    let requestLoadMore: Driver<Void>
    
    //MARK:- Initialize
    init(gitHubService: GitHubServiceType) {
        
        // properties
        var countPerPage: Int = 30
        var allUsers = [UserModel]()
        
        // Refresh
        let onRefreshing = PublishSubject<Bool>()
        isRefreshing = onRefreshing.asDriver(onErrorJustReturn: false)
        
        // Datasource Array
        let allUser = BehaviorRelay<[AllUserData]>(value: [])
        allUserArray = allUser.asDriver(onErrorJustReturn: [])

        
        // Request All User
        requestAllUserData = Observable<Void>
            .merge([viewWillAppear, didPullToRefresh])
            .do { onRefreshing.onNext(true) }
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .flatMapLatest {
                return gitHubService.requestGitHubAllUser(since: 0)
                    .retry(2)
                    .do { onRefreshing.onNext(false) }
            }
            .map{ userModel -> [UserModel] in
                let _ = userModel.map { allUsers.append($0) }
                return allUsers
            }
            .map { [AllUserData(model: "", items: $0)] }
            .map { allUser.accept($0) }
            .asDriver(onErrorJustReturn: ())
        
        
        // Cell Selected
         showUserRepositories = didCellSelected
            .map { $0.name }
            .asDriver(onErrorJustReturn: "")
        
        
        // WiiDisplacy LoadMore
        requestLoadMore = willDisplayCell
            .filter { (_, indexPath) in
                if indexPath.row + 1 == countPerPage {
                    /*
                     < Issue >
                     Get all users의 Response중 없는 유저도 있어서 불러오는 갯수와 ID가 같지 않아 불러올때 중복되는 부분.
                    */
                    countPerPage += Constant.repositoriesCountPerPage
                    return true
                }
                return false
            }
            .do { onRefreshing.onNext(true) }
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .flatMapLatest { _ in
                return gitHubService.requestGitHubAllUser(since: countPerPage)
                    .retry(2)
                    .do { onRefreshing.onNext(false) }
            }
            .map{ userModel -> [UserModel] in
                let _ = userModel.map { allUsers.append($0) }
                return allUsers
            }
            .map { [AllUserData(model: "", items: $0)] }
            .map { allUser.accept($0) }
            .asDriver(onErrorJustReturn: ())
        
    }
    
}
