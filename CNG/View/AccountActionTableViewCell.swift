//
//  AccountActionTableViewCell.swift
//  CNG
//
//  Created by Quang on 08/05/2018.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

class AccountActionTableViewCell: BaseTableCell {
    
    fileprivate let view: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.layer.borderWidth = 0.5
        view.layer.borderColor = DColor.grayColor.cgColor
        view.backgroundColor = DColor.whiteColor
        return view
    }()
    
    fileprivate let label: UILabel = {
        let view = UILabel()
        view.textColor = DColor.blackColor
        view.textAlignment = NSTextAlignment.left
        view.font = DFont.fontLight(size: 16)
        return view
    }()

    fileprivate let imgView: UIImageView = {
        let view = UIImageView()
        
        return view
    }()
    
    var typeAction: TypeActionOfAccount? {
        willSet{
            self.label.text = newValue?.getTitle()
            self.imgView.image = UIImage(named: (newValue?.getImage())!)
            self.imgView.image = self.imgView.image!.withRenderingMode(.alwaysTemplate)
            self.imgView.tintColor = DColor.readColor
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = DColor.grayColor
        self.addSubview(view)
        self.view.addSubview(imgView)
        self.view.addSubview(label)
        
        self.view.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        self.imgView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(0)
            make.height.equalToSuperview().multipliedBy(1.0/2.0)
            make.width.equalTo(self.imgView.snp.height).multipliedBy(1.0/1.0)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        self.label.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().offset(0)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalTo(self.imgView.snp.leading).offset(-5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
