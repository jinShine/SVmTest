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
        static let estimatedRowHeight = CGFloat(60)
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
    
    private let indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        return indicator
    }()
    
    
    
    //MARK:- Properties
    
    var viewModel: AllUserViewModelType!
    var disposeBag: DisposeBag!
    
    
    //MARK:- Setup UI
    
    func setupUI() {
        
        [tableView, indicatorView].forEach { view.addSubview($0) }
        
        // TableView
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        // Indicator
        indicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    //MARK:- -> Event Binding
    
    func setupEventBinding() {
        
        rx.viewWillAppear
            .bind(to: viewModel.viewWillAppear)
            .disposed(by: self.disposeBag)
    }
    
    //MARK:- <- Rx UI Binding
    
    func setupUIBinding() {
        
        let datasource = RxTableViewSectionedReloadDataSource<AllUserData>(configureCell: { (_, tableView, indexPath, item) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AllUserTableViewCell.self)) as? AllUserTableViewCell else { return UITableViewCell() }
            print("ITEMMMMMMMMMMMM!!!!!!!!!!!", item)
            return cell
        })
        
        viewModel.allUserArray
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: self.disposeBag)
    }
    
    //MARK:- Action Handler
    
}
