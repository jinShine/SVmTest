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
    
    
    //MARK:- UI Properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = UI.estimatedHeaderHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UI.estimatedRowHeight
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = .gray
        tableView.register(UserInfomationHeaderCell.self, forHeaderFooterViewReuseIdentifier: String(describing: UserInfomationHeaderCell.self))
        tableView.register(UserRepositoriesCell.self, forCellReuseIdentifier: String(describing: UserRepositoriesCell.self))
        return tableView
    }()
    
    
    
    //MARK:- Properties
    
    private var userName: String?
    private var gitHubService: GitHubServiceType?
    private var userDetailModel = UserDetailModel()
    private var userRepositories = [UserRepositoryModel]()
    
    
    
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
        
        
        
        gitHubService?.requestGitHubUserDetail(name: userName ?? "", completion: { [weak self] response in
            switch response {
            case .success(let userDetailModel):
                self?.userDetailModel = userDetailModel
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        })
        
        gitHubService?.requestGitHubUserRepositories(name: userName ?? "", completion: { [weak self] response in
            switch response {
            case .success(let userRepositoriesModel):
                self?.userRepositories = userRepositoriesModel
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        })
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
    
    
    
    
    //MARK:- Action Handle
    
    
    
    
    
}

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


extension UserRepositoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: UserInfomationHeaderCell.self)
            ) as? UserInfomationHeaderCell else { return UITableViewCell() }
        
        print(userDetailModel)
        cell.configure(with: userDetailModel)
        
        return cell
    }
}
