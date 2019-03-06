//
//  AllUserTableViewCell.swift
//  SVmiOS
//
//  Created by 승진김 on 06/03/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import UIKit

final class AllUserTableViewCell: UITableViewCell {
    
    //MARK:- Constant
    
    private struct UI {
        static let userImageSize: CGFloat = 50
    }
    
    
    //MAKR:- UI Properties
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    let userUniqueID: UILabel = {
        let label = UILabel()
        label.text = "text"
        return label
    }()
    
    let userLoginName: UILabel = {
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
        
        [userImageView, userUniqueID, userLoginName].forEach { addSubview($0) }
        
        // UserImage
        userImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.size.equalTo(UI.userImageSize)
        }
        
        // ID
        userUniqueID.snp.makeConstraints {
            $0.top.equalTo(userImageView.snp.top).offset(8)
            $0.leading.equalTo(userImageView.snp.trailing).offset(8)
        }
        
        // Login
        
        
    }
    
}
