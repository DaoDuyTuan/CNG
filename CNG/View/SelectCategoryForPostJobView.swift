//
//  SelectCategoryForPostJobView.swift
//  CNG
//
//  Created by Quang on 6/9/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

protocol SelectInforForPostJobDelegate {
    func selectCategoryId(category_id: Int)
    func didSlectCategoryId(category_id: Int)
    func selectJobId(job_id: Int)
    func didSelectJobId(job_id: Int)
}

class SelectCategoryForPostJobView: UIView {

    fileprivate let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = DColor.whiteColor
        return tableView
    }()
    
    fileprivate var listCategory = ["Cơ điện", "Xây dựng", "Nội thất"]
    fileprivate var listStyle = ["Thi công", "Mua bán", "Tìm đối tác", "Tìm thợ", "Tuyển dụng(Đối tượng là kĩ sư)"]
    
    fileprivate var category_id = 0
    fileprivate var job_id = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ItemCategory.registerCellByClass(self.tableView)
        ItemStyle.registerCellByClass(self.tableView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.addSubview(tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview().offset(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SelectCategoryForPostJobView: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return listCategory.count
        } else {
            return listStyle.count
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = DColor.grayColor
        let label = UILabel()
        label.textColor = DColor.blackColor
        label.textAlignment = NSTextAlignment.left
        label.font = DFont.fontLight(size: 16)
        if section == 0 {
            label.text = "Ngành nghề"
        } else {
            label.text = "Mảng"
        }
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(20)
            make.top.bottom.equalToSuperview().offset(0)
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = ItemCategory.loadCell(tableView) as! ItemCategory
            if category_id == (indexPath.row + 1) {
                cell.setData(category: self.listCategory[indexPath.row], isSelected: true, index: (indexPath.row + 1), selectAddressDelegate: self)
            } else {
                cell.setData(category: self.listCategory[indexPath.row], isSelected: false, index: (indexPath.row + 1), selectAddressDelegate: self)
            }
            return cell
        } else {
            let cell = ItemStyle.loadCell(tableView) as! ItemStyle
            if job_id == (indexPath.row + 1) {
                cell.setData(style: self.listStyle[indexPath.row], isSelected: true, index: (indexPath.row + 1), selectAddressDelegate: self)
            } else {
                cell.setData(style: self.listStyle[indexPath.row], isSelected: false, index: (indexPath.row + 1), selectAddressDelegate: self)
            }
            return cell
        }
    }
}

extension SelectCategoryForPostJobView: SelectInforForPostJobDelegate {
    func didSlectCategoryId(category_id: Int) {
        if self.category_id == category_id {
            self.category_id = 0
        }
//       self.tableView.reloadData()
    }
    
    func didSelectJobId(job_id: Int) {
        if self.job_id == job_id {
            self.job_id = 0
        }
//        self.tableView.reloadData()
    }
    
    func selectCategoryId(category_id: Int) {
        self.category_id = category_id
//        self.tableView.reloadData()
    }
    
    func selectJobId(job_id: Int) {
        self.job_id = job_id
//        self.tableView.reloadData()
    }
}

class ItemCategory: BaseTableCell {
    
    fileprivate var label: UILabel = {
        let view = UILabel()
        view.textColor = DColor.blackColor
        view.font = DFont.fontLight(size: 17)
        view.textAlignment = NSTextAlignment.left
        return view
    }()
    
    fileprivate var checkBox: UICheckbox = {
        let checkbox = UICheckbox()
        checkbox.borderColor = DColor.blackColor
        checkbox.borderWidth = 1
        checkbox.cornerRadius = 15
        checkbox.backgroundColor = DColor.whiteColor
        return checkbox
    }()
    
    var category: String?
    var index: Int?
    var selectAddressDelegate: SelectInforForPostJobDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(checkBox)
        self.addSubview(label)
        
        self.checkBox.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview().offset(0)
            make.height.equalToSuperview().multipliedBy(1.0/2.0)
            make.width.equalTo(self.checkBox.snp.height).multipliedBy(1.0/1.0)
        }
        
        self.label.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.checkBox.snp.leading).offset(-10)
            make.top.bottom.equalToSuperview().offset(0)
            make.leading.equalToSuperview().offset(20)
        }
     
        self.checkBox.onSelectStateChanged = { (checkbox, selected) in
            if selected == true {
                self.selectAddressDelegate?.selectCategoryId(category_id: self.index!)
            } else {
                self.checkBox.isSelected = true
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(category: String, isSelected: Bool, index: Int, selectAddressDelegate: SelectInforForPostJobDelegate) {
        self.category = category
        self.index = index
        self.label.text = category
        self.checkBox.isSelected = isSelected
        self.selectAddressDelegate = selectAddressDelegate
    }
    
}

class ItemStyle: BaseTableCell {
    
    fileprivate var label: UILabel = {
        let view = UILabel()
        view.textColor = DColor.blackColor
        view.font = DFont.fontLight(size: 17)
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
    
    var style: String?
    var index: Int?
    var selectAddressDelegate: SelectInforForPostJobDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(checkBox)
        self.addSubview(label)
        
        self.checkBox.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview().offset(0)
            make.height.equalToSuperview().multipliedBy(1.0/2.0)
            make.width.equalTo(self.checkBox.snp.height).multipliedBy(1.0/1.0)
        }
        
        self.label.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.checkBox.snp.leading).offset(-10)
            make.top.bottom.equalToSuperview().offset(0)
            make.leading.equalToSuperview().offset(20)
        }
        
        self.checkBox.onSelectStateChanged = { (checkbox, selected) in
            if selected == true {
                self.selectAddressDelegate?.selectJobId(job_id: self.index!)
            } else {
                self.checkBox.isSelected = true
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(style: String, isSelected: Bool, index: Int, selectAddressDelegate: SelectInforForPostJobDelegate) {
        self.style = style
        self.index = index
        self.label.text = style
        self.checkBox.isSelected = isSelected
        self.selectAddressDelegate = selectAddressDelegate
    }
}



