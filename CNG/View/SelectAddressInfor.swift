//
//  SelectAddressInfor.swift
//  CNG
//
//  Created by Quang on 5/10/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

class SelectAddressInfor: UIView {
    
    fileprivate var viewContent: UIView = {
        let view = UIView()
        view.backgroundColor = DColor.whiteColor
        return view
    }()
    
    fileprivate var labelTitle: UILabel = {
        let view = UILabel()
        view.text = "Chọn khu vực"
        view.textColor = DColor.blackColor
        view.font = DFont.fontBold(size: 18)
        view.textAlignment = NSTextAlignment.left
        return view
    }()
    
    var textFieldSearch:UITextField = {
        let view = UITextField()
        view.font = DFont.fontLight(size: 17)
        view.textColor = UIColor.black
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.backgroundColor = DColor.grayColor
        
        let rightView = UIView()
        rightView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        view.rightView = rightView
        view.rightViewMode = .always
        
        let leftView = UIImageView(image: #imageLiteral(resourceName: "ic_search"))
        leftView.contentMode = .scaleAspectFit
        leftView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        view.leftView = leftView
        view.leftViewMode = .always
        
        return view
    }()
    
    fileprivate var tableView: UITableView = {
        let table = UITableView()
        
        return table
    }()
    
    fileprivate var btnOk: UILabel = {
        let view = UILabel()
        view.text = "OK"
        view.textColor = DColor.blackColor
        view.font = DFont.fontBold(size: 16)
        view.textAlignment = .center
        return view
    }()
    
    fileprivate var listAddress = [AddressModel]()
    fileprivate var filter:[AddressModel]?
    fileprivate var listAddressChoose = [AddressModel]()
    
    var addressSelect: ((_ lang: [AddressModel]) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = DColor.blackOpacity15Percent
        SelectAddressInforItem.registerCellByClass(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.addSubview(viewContent)
        self.viewContent.addSubview(labelTitle)
        self.viewContent.addSubview(textFieldSearch)
        self.viewContent.addSubview(tableView)
        self.viewContent.addSubview(btnOk)
        
        self.viewContent.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(6.0/7.0)
            make.height.equalToSuperview().multipliedBy(2.0/3.0)
            make.center.equalToSuperview().offset(0)
        }
        
        self.labelTitle.snp.makeConstraints { (make) in
            make.trailing.top.equalToSuperview().offset(0)
            make.leading.equalToSuperview().offset(15)
            make.height.equalTo(40)
        }
        
        self.textFieldSearch.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalTo(self.labelTitle.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
        
        self.btnOk.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().offset(0)
            make.top.equalTo(self.textFieldSearch.snp.bottom).offset(10)
            make.bottom.equalTo(self.btnOk.snp.top).offset(-10)
        }
        
        self.btnOk.isUserInteractionEnabled = true
        self.btnOk.addTapGesture(target: self, selector: #selector(didTouchOK))
        self.textFieldSearch.addTarget(self, action: #selector(textFieldSearchDidChange(_:)), for: .editingChanged)
    }
    
    func isSearching() -> Bool {
        return !(textFieldSearch.text?.isEmpty)!
    }
    
    @objc func textFieldSearchDidChange(_ textField: UITextField) {
        let textSearch = textField.text?.lowercased().trimSpace()
        filter = listAddress.filter({ (item) -> Bool in
            let langName = item.address?.lowercased()
            return langName!.contains(textSearch!)
        })
        tableView.reloadData()
    }
    
    @objc func didTouchOK()  {
        if let block = addressSelect {
            block(self.listAddressChoose)
        }
        didTouchCancel()
    }
    
    @objc func didTouchCancel() {
        textFieldSearch.resignFirstResponder()
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: self.size.width, height: self.size.height)
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(listAddress: [AddressModel], listAddressChoose: [AddressModel]){
        self.listAddress = listAddress
        self.listAddressChoose = listAddressChoose
        self.tableView.reloadData()
    }
}

extension SelectAddressInfor: UITableViewDelegate, UITableViewDataSource{
    
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SelectAddressInforItem.loadCell(tableView) as! SelectAddressInforItem
        if (self.isSearching()) {
            if let index = listAddressChoose.index(of: (self.filter?[indexPath.row])!){
                cell.setData(address: (self.filter?[indexPath.row])!, selectAddressDelegate: self, isSelect: true)
                self.listAddressChoose.remove(at: index)
            } else {
                cell.setData(address: (self.filter?[indexPath.row])!, selectAddressDelegate: self, isSelect: false)
            }
        } else {
            if let _ = listAddressChoose.index(of: (self.listAddress[indexPath.row])){
                cell.setData(address: self.listAddress[indexPath.row], selectAddressDelegate: self, isSelect: true)
            } else {
                cell.setData(address: self.listAddress[indexPath.row], selectAddressDelegate: self, isSelect: false)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

extension SelectAddressInfor: SelectAddressDelegate {
    
    func selectAddress(address: AddressModel) {
        if listAddressChoose.index(of: address) != nil{
            return
        } else {
            listAddressChoose.append(address)
        }
    }
    
    func didSelectAddress(address: AddressModel) {
        if let index = listAddressChoose.index(of: address){
            self.listAddressChoose.remove(at: index)
        }
    }
    
}

class SelectAddressInforItem: BaseTableCell{
    
    fileprivate var label: UILabel = {
        let view = UILabel()
        view.textColor = DColor.blackColor
        view.font = DFont.fontLight(size: 18)
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
    
    var selectAddressDelegate: SelectAddressDelegate?
    var addressModel: AddressModel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(checkBox)
        self.addSubview(label)
        
        self.checkBox.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview().offset(0)
            make.height.equalToSuperview().multipliedBy(1.0/2.0)
            make.width.equalTo(self.checkBox.snp.height).multipliedBy(1.0/1.0)
        }
        
        self.label.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.top.bottom.equalToSuperview().offset(0)
            make.trailing.equalTo(self.checkBox.snp.leading).offset(-10)
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
    
    func setData(address: AddressModel, selectAddressDelegate: SelectAddressDelegate, isSelect: Bool) {
        self.addressModel = address
        self.label.text = self.addressModel?.address
        self.checkBox.isSelected = isSelect
        self.selectAddressDelegate = selectAddressDelegate
    }
    
}



