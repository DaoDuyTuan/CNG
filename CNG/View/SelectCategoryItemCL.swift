//
//  SelectCategoryItemCL.swift
//  CNG
//
//  Created by Quang on 5/15/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

protocol SelectCategoryDelegate {
    func selectCategory(category: Category)
    func didSelectCategory(category: Category)
}

class SelectCategoryItemCL: BaseCollectionCell {
    
    fileprivate var label: UILabel = {
        let view = UILabel()
        view.textColor = DColor.blackColor
        view.font = DFont.fontLight(size: 14)
        view.textAlignment = NSTextAlignment.left
        return view
    }()
    
    fileprivate var checkBox: UICheckbox = {
        let checkbox = UICheckbox()
        checkbox.borderColor = DColor.blackColor
        checkbox.borderWidth = 1
        checkbox.cornerRadius = 2
        checkbox.backgroundColor = DColor.whiteColor
        return checkbox
    }()
    
    var selectCategoryDelegate: SelectCategoryDelegate?
    var category: Category?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(checkBox)
        self.addSubview(label)
        
        self.checkBox.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview().offset(0)
            make.height.equalToSuperview().multipliedBy(1.0/2.0)
            make.width.equalTo(self.checkBox.snp.height).multipliedBy(1.0/1.0)
        }
        
        self.label.snp.makeConstraints { (make) in
            make.leading.equalTo(self.checkBox.snp.trailing).offset(10)
            make.top.bottom.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(-5)
        }
        
        self.checkBox.onSelectStateChanged = { (checkbox, selected) in
            print("Clicked - \(selected)")
            if selected == true {
                self.selectCategoryDelegate?.selectCategory(category: self.category!)
            } else {
                self.selectCategoryDelegate?.didSelectCategory(category: self.category!)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(category: Category, selectCategoryDelegate: SelectCategoryDelegate, isSelect: Bool) {
        self.category = category
        self.label.text = "\((self.category?.category_name)!)(\((self.category?.countCategory)!))"
        self.checkBox.isSelected = isSelect
        self.selectCategoryDelegate = selectCategoryDelegate
    }
}
