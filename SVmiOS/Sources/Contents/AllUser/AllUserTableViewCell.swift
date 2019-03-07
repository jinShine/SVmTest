//
//  AllUserTableViewCell.swift
//  SVmiOS
//
//  Created by 승진김 on 06/03/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import UIKit
import Kingfisher

final class AllUserTableViewCell: UITableViewCell {
    
    //MARK:- Constant
    
    private struct UI {
        static let basicMargin: CGFloat = 6
        static let userImageSize: CGFloat = 80
    }
    
    
    //MAKR:- UI Properties
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    let idLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let loginLabel: UILabel = {
        let label = UILabel()
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
    
    
    private func setupUI() {
        
        [userImageView, idLabel, loginLabel].forEach { addSubview($0) }
        
        // UserImage
        userImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.size.equalTo(UI.userImageSize)
        }
        
        // ID
        idLabel.snp.makeConstraints {
            $0.top.equalTo(userImageView.snp.top).offset(UI.basicMargin)
            $0.leading.equalTo(userImageView.snp.trailing).offset(UI.basicMargin)
            $0.trailing.equalToSuperview().offset(-UI.basicMargin)
        }
        
        // Login
        loginLabel.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom).offset(UI.basicMargin)
            $0.leading.trailing.equalTo(idLabel)
            $0.bottom.equalToSuperview().offset(-UI.basicMargin)
        }
        
    }
    
    func configure(with user: UserModel) {
        guard let profileURL = URL(string: user.profile) else { return }
        userImageView.kf.setImage(with: profileURL)
        idLabel.text = "\(user.id)"
        loginLabel.text = user.name
    }
    
}
