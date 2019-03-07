//
//  RepositoriesTableViewCell.swift
//  SVmiOS
//
//  Created by 승진김 on 07/03/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import UIKit

class UserRepositoriesCell: UITableViewCell {

    
    //MARK:- Constant
    
    private struct UI {
        static let basicMargin: CGFloat = 6
        static let basicFont: UIFont = UIFont.systemFont(ofSize: 12)
    }
    
    
    //MAKR:- UI Properties
    
    let repositoryNameLabel: UILabel = {
        let label = UILabel()
        label.font = UI.basicFont
        return label
    }()
    
    let startLabel: UILabel = {
        let label = UILabel()
        label.font = UI.basicFont
        label.textAlignment = .right
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UI.basicFont
        label.numberOfLines = 0
        return label
    }()
    
    let watcherLabel: UILabel = {
        let label = UILabel()
        label.font = UI.basicFont
        label.textAlignment = .right
        return label
    }()
    
    let createdAtLabel: UILabel = {
        let label = UILabel()
        label.font = UI.basicFont
        label.textAlignment = .right
        return label
    }()
    
    
    
    //MARK:- Properties
    
    
    //MARK:- Initialize
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Setup
    
    private func setupUI() {
        
        [repositoryNameLabel, startLabel, descriptionLabel, watcherLabel, createdAtLabel].forEach { addSubview($0) }
        
        // RepositoryName
        repositoryNameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(UI.basicMargin)
            $0.trailing.equalTo(startLabel.snp.leading).offset(-UI.basicMargin)
        }
        
        // StartCount
        startLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(UI.basicMargin)
            $0.trailing.equalToSuperview().offset(-UI.basicMargin)
        }
        
        // WatcherCount
        watcherLabel.snp.makeConstraints {
            $0.top.equalTo(startLabel.snp.bottom).offset(UI.basicMargin)
            $0.trailing.equalToSuperview().offset(-UI.basicMargin)
        }
        
        // Description
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(watcherLabel.snp.bottom).offset(UI.basicMargin)
            $0.leading.equalTo(repositoryNameLabel)
            $0.trailing.equalToSuperview().offset(-UI.basicMargin)
        }
        
        // Created
        createdAtLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(UI.basicMargin)
            $0.leading.equalToSuperview().offset(UI.basicMargin)
            $0.trailing.bottom.equalToSuperview().offset(-UI.basicMargin)
        }
        
    }
    
    func configure(with repo: UserRepositoryModel) {
        repositoryNameLabel.text = repo.name
        startLabel.text = "start : \(repo.stargazersCount)"
        descriptionLabel.text = repo.description
        watcherLabel.text = "watcher : \(repo.watchersCount)"
        createdAtLabel.text = convertTimezoneToDate(repo.createdAt)
        
    }
    
    // Method
    
    private func convertTimezoneToDate(_ timezoneString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        guard let date = dateFormatter.date(from: timezoneString) else { return "" }
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        return dateFormatter.string(from: date)
    }
}
