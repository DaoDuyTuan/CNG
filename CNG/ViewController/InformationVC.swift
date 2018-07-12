//
//  InformationVCViewController.swift
//  CNG
//
//  Created by Quang on 03/05/2018.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

class InformationVCViewController: UIViewController {

    fileprivate var scrollView: UIScrollView = {
       let view = UIScrollView(frame: CGRect( x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 64))
        view.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
        view.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 600)
        return view
    }()
    
    fileprivate var imageBack: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "ic_arrow_back_white")
        image.isHidden = true
        return image
    }()
    
    fileprivate var labelTitle: UILabel = {
        let label = UILabel()
        label.text = "Cập nhập thông tin"
        label.textColor = DColor.whiteColor
        label.font = DFont.fontLight(size: 18)
        label.textAlignment = NSTextAlignment.left
        label.isHidden = true
        return label
    }()
    
    fileprivate var viewContent: UIView = {
        let view = UIView(frame: CGRect( x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 600))
        
        return view
    }()
    
    fileprivate var imageAvatar: UIImageView  = {
        let image = UIImageView()
        image.backgroundColor = DColor.whiteColor
        return image
    }()

    fileprivate var nameView: ItemInputInformation  = {
        let view = ItemInputInformation()
        view.typeInfor = TypeInfor.name
        return view
    }()
    
    fileprivate var phoneNumber: ItemInputInformation  = {
        let view = ItemInputInformation()
        view.typeInfor = TypeInfor.phoneNumber
        return view
    }()
    
    fileprivate var city: ItemInputInformation  = {
        let view = ItemInputInformation()
        view.typeInfor = TypeInfor.city
        return view
    }()
    fileprivate var emailView: ItemInputInformation  = {
        let view = ItemInputInformation()
        view.typeInfor = TypeInfor.email
        return view
    }()
    
    fileprivate var job: ItemInputInformation  = {
        let view = ItemInputInformation()
        view.typeInfor = TypeInfor.job
        return view
    }()
    
    fileprivate var style: ItemInputInformation  = {
        let view = ItemInputInformation()
        view.typeInfor = TypeInfor.style
        return view
    }()
    
    fileprivate var sex: ItemInputInformation  = {
        let view = ItemInputInformation()
        view.typeInfor = TypeInfor.sex
        return view
    }()
    
    fileprivate var birthDay: ItemInputInformation  = {
        let view = ItemInputInformation()
        view.typeInfor = TypeInfor.birth
        return view
    }()
    
    fileprivate var btnUpdate: UIButton = {
        let view = UIButton()
        view.setTitle("Cập nhập thông tin", for: .normal)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.backgroundColor = DColor.blueColor
        return view
    }()
    
    var name:  String? {
        willSet{
            self.nameView.setData(data: newValue!)
        }
    }
    
    var email: String? {
        willSet{
            if newValue != nil {
                self.emailView.setData(data: newValue!)
            }
        }
    }
    var id: String?{
        willSet{
            self.imageAvatar.sd_setImage(with: URL(string: "https://graph.facebook.com//\(newValue!)/picture?type=large"), completed: { (image, erroe, type, url) in
            })
            if self.userModel?.id == nil{
                APIManage.shared.getUser(userId: newValue!) { (success, userModel) in
                    if success {
                        if userModel.id != nil {
                            UserModel.userCache = userModel.toDictionary()
                            self.userModel = userModel
                            let addresses = ((self.userModel?.city?.replacingOccurrences(of: "[", with: ""))?.replacingOccurrences(of: "]", with: ""))?.split(separator: ",")
                            if (self.listAddressChoose?.count)! > 0 {
                                
                            } else {
                                for address in  addresses! {
                                    let city = AddressModel(address: String(address), countJob: 0)
                                    self.listAddressChoose?.append(city)
                                }
                                SQLiteManger.getInstance().deleteAllData()
                                for question in self.listAddressChoose! {
                                    SQLiteManger.getInstance().insertAddress(address: question)
                                }
                            }
                            
                            let category = ((self.userModel?.job?.replacingOccurrences(of: "[", with: ""))?.replacingOccurrences(of: "]", with: ""))?.split(separator: ",")
                            if (self.listCategoryChoose.count) > 0 {
                                
                            } else {
                                for item in  category! {
                                    self.listCategoryChoose.append(String(item))
                                }
                                SQLiteManger.getInstance().deleteAllDataCategory()
                                for question in self.listCategoryChoose {
                                    SQLiteManger.getInstance().insertCategory(category: question)
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    var userModel: UserModel?{
        willSet{
            self.listAddressChoose = SQLiteManger.getInstance().getListAddress()
            var paramAddress = String()
            if self.listAddressChoose?.count == 0 {
                paramAddress = "Thành phố"
            } else {
                paramAddress = "["
                for addressCity in 0..<(self.listAddressChoose?.count)! {
                    if addressCity == ((self.listAddressChoose?.count)! - 1) {
                        paramAddress = "\(paramAddress)\"\(self.listAddressChoose![addressCity].address!)]"
                    } else {
                        paramAddress = "\(paramAddress)\(self.listAddressChoose![addressCity].address!),"
                    }
                }
            }
            
            var paramCategory = String()
            if self.listCategoryChoose.count == 0 {
                paramCategory = "Hạng mục"
            } else {
                paramCategory = "["
                for addressCity in 0..<self.listCategoryChoose.count {
                    if addressCity == (self.listCategoryChoose.count - 1) {
                        paramCategory = "\(paramCategory)\"\(self.listCategoryChoose[addressCity])]"
                    } else {
                        paramCategory = "\(paramCategory)\(self.listCategoryChoose[addressCity]),"
                    }
                    
                }
            }
            
            self.city.setData(data: paramAddress)
            self.job.setData(data: paramCategory)
            self.id = (newValue?.id)!
            self.email = (newValue?.email)!
            self.name = (newValue?.name)!
            self.nameView.setData(data: (newValue?.name)!)
            self.phoneNumber.setData(data: (newValue?.phone)!)
            
            self.emailView.setData(data: (newValue?.email)!)
            self.job.setData(data: ((newValue?.job)! == "" ? "Hạng mục" : (newValue?.job)!))
            self.style.setData(data: ((newValue?.kind)! == "" ? "Tất cả" : (newValue?.kind)!))
            self.sex.setData(data: (newValue?.sex)!)
            self.birthDay.setData(data: (newValue?.birth)!)
            self.imageAvatar.sd_setImage(with: URL(string: "https://graph.facebook.com//\((UserModel(data: UserModel.userCache!).id)!)/picture?type=large"), completed: { (image, erroe, type, url) in
                
            })
        }
    }
    
    var listAddressChoose: [AddressModel]? = []
    
    var dismisVC: Bool?{
        willSet{
            if newValue == true {
                self.imageBack.isHidden = false
                self.labelTitle.isHidden = false
            } else {
                self.imageBack.isHidden = true
                self.labelTitle.isHidden = true
            }
        }
    }
    
    fileprivate var listAddress = [AddressModel]()
    fileprivate var listCategory = ["Cơ điện", "Xây dựng", "Nội thất"]
    fileprivate var listCategoryChoose = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.view.backgroundColor = DColor.readColor
        
        initSubLayout()
        initContrains()
        initActionView()
        
        APIManage.shared.getAddress { (sucess, listAddress) in
            if sucess {
                self.listAddress = listAddress
                for address in self.listAddress {
                    for index in 0..<self.listAddressChoose!.count {
                        if self.listAddressChoose![index].address == address.address {
                            self.listAddressChoose![index].countJob = address.countJob
                        }
                    }
                }
                SQLiteManger.getInstance().deleteAllData()
                for question in self.listAddressChoose! {
                    SQLiteManger.getInstance().insertAddress(address: question)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initSubLayout() {
        self.view.addSubview(imageBack)
        self.view.addSubview(labelTitle)
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(viewContent)
        self.viewContent.addSubview(imageAvatar)
        self.viewContent.addSubview(nameView)
        self.viewContent.addSubview(phoneNumber)
        self.viewContent.addSubview(city)
        self.viewContent.addSubview(emailView)
        self.viewContent.addSubview(job)
        self.viewContent.addSubview(style)
        self.viewContent.addSubview(sex)
        self.viewContent.addSubview(birthDay)
        self.viewContent.addSubview(btnUpdate)
        
    }
    
    func initContrains(){
        
        self.imageBack.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(UIDevice.statusBar.rawValue + 5)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        
        self.labelTitle.snp.makeConstraints { (make) in
            make.leading.equalTo(self.imageBack.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(0)
            make.centerY.equalTo(self.imageBack).offset(0)
            make.height.equalTo(self.imageBack).multipliedBy(1.0/1.0)
        }
        
        self.imageAvatar.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(0)
            make.width.equalTo(90)
            make.height.equalTo(self.imageAvatar.snp.width).multipliedBy(1.0/1.0)
            make.top.equalTo(20)
        }
        
        self.nameView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(70)
            make.top.equalTo(self.imageAvatar.snp.bottom).offset(30)
        }
        
        self.phoneNumber.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(self.nameView.snp.bottom).offset(10)
            make.width.equalTo(self.nameView.snp.width).multipliedBy(1.0/2.0)
            make.height.equalTo(self.nameView.snp.height).multipliedBy(1.0/1.0)
        }

        self.city.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(self.nameView.snp.bottom).offset(10)
            make.height.equalTo(self.nameView.snp.height).multipliedBy(1.0/1.0)
            make.leading.equalTo(self.phoneNumber.snp.trailing).offset(10)
        }

        self.emailView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(self.phoneNumber.snp.bottom).offset(10)
            make.height.equalTo(self.nameView.snp.height).multipliedBy(1.0/1.0)
        }

        self.job.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(self.emailView.snp.bottom).offset(10)
            make.width.equalTo(self.nameView.snp.width).multipliedBy(1.0/2.0)
            make.height.equalTo(self.nameView.snp.height).multipliedBy(1.0/1.0)
        }

        self.style.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalTo(self.job).offset(0)
            make.height.equalTo(self.nameView.snp.height).multipliedBy(1.0/1.0)
            make.leading.equalTo(self.job.snp.trailing).offset(10)
        }

        self.sex.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(self.job.snp.bottom).offset(10)
            make.width.equalTo(self.nameView.snp.width).multipliedBy(1.0/2.0)
            make.height.equalTo(self.nameView.snp.height).multipliedBy(1.0/1.0)
        }

        self.birthDay.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(self.style.snp.bottom).offset(10)
            make.height.equalTo(self.nameView.snp.height).multipliedBy(1.0/1.0)
            make.leading.equalTo(self.sex.snp.trailing).offset(10)
        }

        self.btnUpdate.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(0)
            make.width.equalToSuperview().multipliedBy(2.0/3.0)
            make.height.equalTo(35)
            make.top.equalTo(self.birthDay.snp.bottom).offset(20)
        }
        
    }
    
    func initActionView() {
        self.btnUpdate.addTarget(self, action: #selector(updateInfor), for: .touchUpInside)
        self.imageBack.isUserInteractionEnabled = true
        self.imageBack.addTapGesture(target: self, selector: #selector(back))
        
        self.city.isUserInteractionEnabled = true
        self.city.addTapGesture(target: self, selector: #selector(seclectCity))
        
        self.job.isUserInteractionEnabled = true
        self.job.addTapGesture(target: self, selector: #selector(seclectCategoty))
        
    }
    
    @objc func updateInfor() {
        if (self.nameView.checkNilValue() && self.phoneNumber.checkNilValue() && self.city.checkNilValue() && self.emailView.checkNilValue() && self.job.checkNilValue() && self.style.checkNilValue()) {
            let user = UserModel()
            user.id = id
            user.name = self.nameView.getData()
            user.phone = self.phoneNumber.getData()
            user.facebook = "https://www.facebook.com/1902835423340396\(id!)"
            user.email = self.emailView.getData()
            user.job = self.job.getData()
            user.kind = self.style.getData()
            user.sex = self.sex.getData()
            user.birth = self.birthDay.getData()
            user.city = self.city.getData()
            APIManage.shared.updateProfile(user: user) { (success) in
                SQLiteManger.getInstance().deleteAllData()
                for question in self.listAddressChoose! {
                    SQLiteManger.getInstance().insertAddress(address: question)
                }
                SQLiteManger.getInstance().deleteAllDataCategory()
                for question in self.listCategoryChoose {
                    SQLiteManger.getInstance().insertCategory(category: question)
                }
                
                if success {
                    UserModel.userCache = user.toDictionary()
                    if self.dismisVC != true{
                        self.present(TabbarVC(), animated: true, completion: nil)
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    UIAlertController.customInit().showDefault(title: "Thộng báo", message: "Cập nhập thông tin xảy lỗi")
                }
            }
        } else {
            UIAlertController.customInit().showDefault(title: "Thộng báo", message: "Các thông tin Tên, Số điện thoại, Thành phố, Email, Ngành nghề, Mảng là bắt buộc")
        }
    }
    
    @objc func back() {
        self.dismiss(animated: true, completion : nil)
    }
    
    @objc func seclectCity() {
        let selectAddress = SelectAddress()
        selectAddress.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        selectAddress.setData(listAddress: self.listAddress, listAddressChoose: self.listAddressChoose!)
        selectAddress.addressSelect = { (address) in
            self.listAddressChoose = address
            var paramAddress = String()
            if self.listAddressChoose?.count == 0 {
                paramAddress = "Thành phố"
            } else {
                paramAddress = "["
                for addressCity in 0..<(self.listAddressChoose?.count)! {
                    if addressCity == ((self.listAddressChoose?.count)! - 1) {
                        paramAddress = "\(paramAddress)\(self.listAddressChoose![addressCity].address!)]"
                    } else {
                        paramAddress = "\(paramAddress)\(self.listAddressChoose![addressCity].address!),"
                    }
                }
            }
            self.city.setData(data: paramAddress)
        }
        self.view.addSubview(selectAddress)
    }
    
    @objc func seclectCategoty() {
        let selectCategory = SelectCategory()
        selectCategory.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        selectCategory.setData(listCategory: self.listCategory, listCategoryCurrent: self.listCategoryChoose)
        selectCategory.categorySelect = { (category) in
            self.listCategoryChoose = category
            var paramCategory = String()
            if self.listCategoryChoose.count == 0 {
                paramCategory = "Hạng mục"
            } else {
                paramCategory = "["
                for addressCity in 0..<self.listCategoryChoose.count {
                    if addressCity == (self.listCategoryChoose.count - 1) {
                        paramCategory = "\(paramCategory)\(self.listCategoryChoose[addressCity])]"
                    } else {
                        paramCategory = "\(paramCategory)\(self.listCategoryChoose[addressCity]),"
                    }
                    
                }
            }
            self.job.setData(data: paramCategory)
        }
        self.view.addSubview(selectCategory)
    }
    
}

extension InformationVCViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RequestViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
