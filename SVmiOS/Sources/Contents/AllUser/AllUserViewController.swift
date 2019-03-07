//
//  AllUserViewController.swift
//  SVmiOS
//
//  Created by 승진김 on 06/03/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources
import SnapKit


final class AllUserViewController: UIViewController, ViewType {
    
    //MARK:- Constant
    
    struct UI {
        static let estimatedRowHeight = CGFloat(80)
    }
    
    //MARK:- UI Properties
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.plain)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UI.estimatedRowHeight
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = .gray
        tableView.register(AllUserTableViewCell.self, forCellReuseIdentifier: String(describing: AllUserTableViewCell.self))
        return tableView
    }()
    
    //MARK:- Properties
    
    var viewModel: AllUserViewModelType!
    var disposeBag: DisposeBag!
    
    
    //MARK:- Setup UI
    
    func setupUI() {
        
        [tableView].forEach { view.addSubview($0) }
        
        // TableView
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    
    //MARK:- -> Event Binding
    
    func setupEventBinding() {
        
        rx.viewWillAppear
            .bind(to: viewModel.viewWillAppear)
            .disposed(by: self.disposeBag)
        
        tableView.refreshControl?.rx.controlEvent(UIControlEvents.valueChanged)
            .bind(to: viewModel.didPullToRefresh)
            .disposed(by: self.disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        
        tableView.rx.willDisplayCell
            .debug()
            .bind(to: viewModel.willDisplayCell)
            .disposed(by: self.disposeBag)
        
        tableView.rx.modelSelected(UserModel.self)
            .bind(to: viewModel.didCellSelected)
            .disposed(by: disposeBag)
        
    }
    
    //MARK:- <- Rx UI Binding
    
    func setupUIBinding() {
        
        let datasource = RxTableViewSectionedReloadDataSource<AllUserData>(configureCell: { (_, tableView, indexPath, item) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AllUserTableViewCell.self)) as? AllUserTableViewCell else { return UITableViewCell() }
            print("Datasource :", item)
            cell.configure(with: item)
            return cell
        })
        
        viewModel.allUserArray
            .debug("123123123")
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: self.disposeBag)
        
        viewModel.isRefreshing
            .drive(onNext: { [weak self] isRefreshing in
                self?.showRefreshingAnimation(isRefreshing)
            })
            .disposed(by: self.disposeBag)
        
        viewModel.showUserRepositories
            .drive(onNext: { [weak self] userName in
                let userRepositoriesViewController = ProvideObject.userRepositories(name: userName).viewController
                self?.navigationController?.pushViewController(userRepositoriesViewController, animated: true)
            })
            .disposed(by: self.disposeBag)
                
//        viewModel.loadMore
//            .drive(tableView.rx.items(dataSource: datasource))
//            .disposed(by: self.disposeBag)
        
    }
    
    //MARK:- Action Handler
    
    private func showRefreshingAnimation(_ isRefreshing: Bool) {
        if !isRefreshing {
            tableView.refreshControl?.endRefreshing()
        }
    }
}

extension AllUserViewController: UITableViewDelegate {
    
}
