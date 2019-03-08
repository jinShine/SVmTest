//
//  UserInfomationHeaderCell.swift
//  SVmiOS
//
//  Created by 승진김 on 07/03/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import UIKit
import Kingfisher

class UserInfomationHeaderCell: UITableViewHeaderFooterView {

    //MARK:- Constant
    
    private struct UI {
        static let basicMargin: CGFloat = 6
        static let userImageSize: CGFloat = 150
        static let basicFont: UIFont = UIFont.systemFont(ofSize: 12)
    }
    
    
    //MAKR:- UI Properties
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    let loginLabel: UILabel = {
        let label = UILabel()
        label.font = UI.basicFont
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UI.basicFont
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UI.basicFont
        return label
    }()
    
    let companyLabel: UILabel = {
        let label = UILabel()
        label.font = UI.basicFont
        return label
    }()
    
    let followsValueLabel: UILabel = {
        let label = UILabel()
        label.font = UI.basicFont
        label.textAlignment = .left
        return label
    }()
    
    let followingValueLabel: UILabel = {
        let label = UILabel()
        label.font = UI.basicFont
        label.textAlignment = .right
        return label
    }()
    
    //MARK:- Properties
    
    
    //MARK:- Initialize
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        [userImageView, loginLabel, nameLabel, locationLabel, companyLabel,
         followsValueLabel, followingValueLabel].forEach { addSubview($0) }
        
        // UserImage
        userImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.size.equalTo(UI.userImageSize)
        }
        
        // Login
        loginLabel.snp.makeConstraints {
            $0.top.equalTo(userImageView.snp.top).offset(UI.basicMargin)
            $0.leading.equalTo(userImageView.snp.trailing).offset(UI.basicMargin)
            $0.trailing.equalToSuperview().offset(-UI.basicMargin)
        }
        
        // Name
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(loginLabel.snp.bottom).offset(UI.basicMargin)
            $0.leading.trailing.equalTo(loginLabel)
        }
        
        // Location
        locationLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(UI.basicMargin)
            $0.leading.trailing.equalTo(nameLabel)
        }
        
        // Company
        companyLabel.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom).offset(UI.basicMargin)
            $0.leading.trailing.equalTo(locationLabel)
        }

        // Followers Value
        followsValueLabel.snp.makeConstraints {
            $0.top.equalTo(companyLabel.snp.bottom).offset(UI.basicMargin)
            $0.leading.equalTo(companyLabel)
        }
        
        // Following Value
        followingValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(followsValueLabel)
            $0.leading.equalTo(followsValueLabel.snp.trailing).offset(UI.basicMargin * 3)
            $0.trailing.equalToSuperview().offset(-UI.basicMargin)
        }
    }
    
    func configure(with userDetailModel: UserDetailModel) {
        guard let profileURL = URL(string: userDetailModel.profile ?? "") else { return }
        userImageView.kf.setImage(with: profileURL)
        loginLabel.text = userDetailModel.login
        nameLabel.text = userDetailModel.name
        locationLabel.text = userDetailModel.location
        companyLabel.text = userDetailModel.company
        followsValueLabel.text = "follows : \(userDetailModel.followers)"
        followingValueLabel.text = "following : \(userDetailModel.following)"
    }
    
}
