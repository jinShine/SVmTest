//
//  UserRepositoriesViewController.swift
//  SVmiOS
//
//  Created by 승진김 on 07/03/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import UIKit
import SnapKit

final class UserRepositoriesViewController: UIViewController {
    
    //MARK:- UI Constant
    
    private struct UI {
        static let estimatedHeaderHeight: CGFloat = 150
        static let estimatedRowHeight: CGFloat = 80
    }
    
    private struct Constant {
        static let repositoriesCountPerPage: Int = 30
    }
    
    //MARK:- UI Properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = UI.estimatedHeaderHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UI.estimatedRowHeight
        tableView.refreshControl = refreshControl
        tableView.register(UserInfomationHeaderCell.self, forHeaderFooterViewReuseIdentifier: String(describing: UserInfomationHeaderCell.self))
        tableView.register(UserRepositoriesCell.self, forCellReuseIdentifier: String(describing: UserRepositoriesCell.self))
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    
    
    //MARK:- Properties
    
    private var userName: String?
    private var gitHubService: GitHubServiceType?
    private var userDetailModel = UserDetailModel()
    private var userRepositories = [UserRepositoryModel]()
    private var countPerPage: Int = 30
    private var pageCount: Int = 1
    
    
    //MARK:- Initialize
    
    init(userName: String, gitHubService: GitHubServiceType) {
        super.init(nibName: nil, bundle: nil)
        self.userName = userName
        self.gitHubService = gitHubService
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.fetchUserDetail()
        fetchUserRepositories(page: pageCount)
    }
    
    

    
    //MARK:- Setup
    
    private func setupUI() {
        
        [tableView].forEach { view.addSubview($0) }
        
        // TableView
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    
    
    
    
}

//MARK:- Action Handle
extension UserRepositoriesViewController {
    
    @objc private func refresh() {
        fetchUserDetail()
        fetchUserRepositories(page: countPerPage)
        self.refreshControl.endRefreshing()
    }
    
    private func fetchUserDetail() {
        gitHubService?.requestGitHubUserDetail(name: userName ?? "", completion: { [weak self] response in
            switch response {
            case .success(let userDetailModel):
                DispatchQueue.main.async {
                    self?.userDetailModel = userDetailModel
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(ServiceError.requestFailed(error))
            }
        })
    }
    
    private func fetchUserRepositories(page: Int) {
        gitHubService?.requestGitHubUserRepositories(name: userName ?? "", page: page, completion: { [weak self] response in
            switch response {
            case .success(let userRepositoriesModel):
                DispatchQueue.main.async {
                    let _ = userRepositoriesModel.map { self?.userRepositories.append($0) }
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(ServiceError.requestFailed(error))
            }
        })
    }
}

//MARK:- TableView DataSource
extension UserRepositoriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userRepositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserRepositoriesCell.self), for: indexPath) as? UserRepositoriesCell else { return UITableViewCell() }

        cell.configure(with: userRepositories[indexPath.row])

        return cell
    }
}

//MARK:- TableView Delegate
extension UserRepositoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: UserInfomationHeaderCell.self)
            ) as? UserInfomationHeaderCell else { return UITableViewCell() }

        cell.configure(with: userDetailModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // LoadMore
        if indexPath.row + 1 == countPerPage {
            countPerPage += Constant.repositoriesCountPerPage
            pageCount += 1
            fetchUserRepositories(page: pageCount)
        }
    }
}
