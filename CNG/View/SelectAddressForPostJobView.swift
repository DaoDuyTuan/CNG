//
//  SelectAddressForPostJobView.swift
//  CNG
//
//  Created by Quang on 6/9/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

protocol SelectAddressForPostJobDelegate {
    func selectAddress(address: AddressModel)
    func didSelectAddress(address: AddressModel)
}

class SelectAddressForPostJobView: UIView {

    var textFieldSearch:UITextField = {
        let view = UITextField()
        view.font = DFont.fontLight(size: 17)
        view.textColor = UIColor.black
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = DColor.grayColor.cgColor
        view.backgroundColor = DColor.whiteColor
        let rightView = UIView()
        rightView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        view.rightView = rightView
        view.rightViewMode = .always
        
        let leftView = UIImageView(image: #imageLiteral(resourceName: "ic_search"))
        leftView.contentMode = .scaleAspectFit
        leftView.image = leftView.image!.withRenderingMode(.alwaysTemplate)
        leftView.tintColor = DColor.blackColor
        leftView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        view.leftView = leftView
        view.leftViewMode = .always
        
        return view
    }()
    
    fileprivate let label: UILabel = {
        let label = UILabel()
        label.text = "Danh sách khu vực"
        label.textColor = DColor.blackColor
        label.textAlignment = NSTextAlignment.left
        label.font = DFont.fontLight(size: 16)
        return label
    }()
    
    fileprivate let collectionView: UITableView = {
        let collectionView = UITableView()
        collectionView.backgroundColor = DColor.whiteColor
        return collectionView
    }()
    
    var selectAddressForAddDelegate: SelectAddressForAddDelegate?
    fileprivate var filter:[AddressModel]?
    fileprivate var listAddress = [AddressModel]()
    fileprivate var listAddressChoose = [AddressModel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = DColor.whiteColor
        ItemAddress.registerCellByClass(self.collectionView)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.addSubview(textFieldSearch)
        self.addSubview(label)
        self.addSubview(collectionView)
        
        self.textFieldSearch.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(40)
        }
        
        self.label.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalTo(self.textFieldSearch.snp.bottom).offset(20)
            make.height.equalTo(30)
            make.top.equalTo(self.textFieldSearch.snp.bottom).offset(20)
        }
        
        self.collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview().offset(0)
            make.top.equalTo(self.label.snp.bottom).offset(10)
        }
        
        APIManage.shared.getAddress { (sucess, listAddress) in
            if sucess {
                self.listAddress = listAddress
                self.listAddress.remove(at: self.listAddress.count - 1)
                self.listAddress.remove(at: 0)
                self.collectionView.reloadData()
            }
        }
        
        self.textFieldSearch.addTarget(self, action: #selector(textFieldSearchDidChange(_:)), for: .editingChanged)
        
    }
    
    @objc func textFieldSearchDidChange(_ textField: UITextField) {
        let textSearch = textField.text?.lowercased().trimSpace()
        filter = listAddress.filter({ (item) -> Bool in
            let langName = item.address?.lowercased()
            return langName!.contains(textSearch!)
        })
        collectionView.reloadData()
    }
    
    func isSearching() -> Bool {
        return !(textFieldSearch.text?.isEmpty)!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func checkInListAddress(listAddress: [AddressModel], address: AddressModel) -> Bool {
        for item in listAddress {
            if item.address == address.address {
                return true
            }
        }
        return false
    }
    
    func getInListAddress(listAddress: [AddressModel], address: AddressModel) -> Int {
        for item in 0..<listAddress.count {
            if listAddress[item].address == address.address {
                return item
            }
        }
        return -1
    }
    
}

extension SelectAddressForPostJobView: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.isSearching()) {
            return (filter?.count)!
        } else {
            return self.listAddress.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ItemAddress.loadCell(tableView) as! ItemAddress
        if (self.isSearching()) {
            if checkInListAddress(listAddress: self.listAddressChoose, address: self.filter![indexPath.row]){
                cell.setData(address: (self.filter?[indexPath.row])!, selectAddressDelegate: self, isSelect: true)
                self.listAddressChoose.remove(at: getInListAddress(listAddress: self.listAddressChoose, address: self.filter![indexPath.row]))
            } else {
                cell.setData(address: (self.filter?[indexPath.row])!, selectAddressDelegate: self, isSelect: false)
            }
            
        } else {
            if checkInListAddress(listAddress: self.listAddressChoose, address: self.listAddress[indexPath.row]){
                cell.setData(address: self.listAddress[indexPath.row], selectAddressDelegate: self, isSelect: true)
            } else {
                cell.setData(address: self.listAddress[indexPath.row], selectAddressDelegate: self, isSelect: false)
            }
        }
        return cell
    }
}

extension SelectAddressForPostJobView: SelectAddressForPostJobDelegate {
    
    func selectAddress(address: AddressModel) {
        if listAddressChoose.index(of: address) != nil{
            return
        } else {
            listAddressChoose.append(address)
        }
        if selectAddressForAddDelegate != nil {
            selectAddressForAddDelegate?.selectAddress(address: self.listAddressChoose)
        }
    }
    
    func didSelectAddress(address: AddressModel) {
        if let index = listAddressChoose.index(of: address){
            self.listAddressChoose.remove(at: index)
        }
        if selectAddressForAddDelegate != nil {
            selectAddressForAddDelegate?.selectAddress(address: self.listAddressChoose)
        }
    }
    
}

class ItemAddress: BaseTableCell {
    
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
    
    var selectAddressDelegate: SelectAddressForPostJobDelegate?
    var addressModel: AddressModel?
    
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
                self.selectAddressDelegate?.selectAddress(address: self.addressModel!)
            } else {
                self.selectAddressDelegate?.didSelectAddress(address: self.addressModel!)
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(address: AddressModel, selectAddressDelegate: SelectAddressForPostJobDelegate, isSelect: Bool) {
        self.addressModel = address
        self.label.text = "\((self.addressModel?.address)!)"
        self.checkBox.isSelected = isSelect
        self.selectAddressDelegate = selectAddressDelegate
    }
    
}
