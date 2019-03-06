//
//  AllUserViewController.swift
//  SVmiOS
//
//  Created by 승진김 on 06/03/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import RxSwift
import RxCocoa

final class AllUserViewController: UIViewController, ViewType {
    
    //MARK:- UI Metrics
    
    struct UI {
        
    }
    
    //MARK:- UI Properties
    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    //MARK:- Properties
    
    var viewModel: AllUserViewModelType!
    var disposeBag: DisposeBag!
    
    //MARK:- Setup UI
    
    func setupUI() {
        
    }
    
    //MARK:- -> Event Binding
    
    func setupEventBinding() {
        
    }
    
    //MARK:- <- Rx UI Binding
    
    func setupUIBinding() {
        
    }
    
    //MARK:- Action Handler
    
}
