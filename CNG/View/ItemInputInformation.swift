//
//  ItemInputInformation.swift
//  CNG
//
//  Created by Quang on 03/05/2018.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit
import SnapKit
import DropDown
import DatePickerDialog

public enum TypeInfor : String {
    case name = "Họ và tên"
    case phoneNumber = "Số điện thoại"
    case city = "Thành phố"
    case email = "Email"
    case job = "Hạng mục"
    case style = "Mảng"
    case sex = "Giới tính"
    case birth = "Ngày sinh"
    
    func checkCompulsory() -> Bool {
        switch self {
        case .name:
            return true
        case .phoneNumber:
            return true
        case .city:
            return true
        case .email:
            return true
        case .job:
            return true
        case .style:
            return true
        case .sex:
            return false
        case .birth:
            return false
        }
        
    }
    
}
class ItemInputInformation: UIView {
    
    fileprivate let label: UILabel = {
        let label = UILabel()
        label.textColor = DColor.whiteColor
        label.font = DFont.fontLight(size: 16)
        label.textAlignment = .left
        return label
    }()
    
    fileprivate let view: UIView = {
        let view = UIView()
        view.backgroundColor = DColor.whiteColor
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate let textField: UITextField = {
        let textField = UITextField()
        textField.textColor = DColor.blackColor
        textField.font = DFont.fontLight(size: 16)
        return textField
    }()
    
    fileprivate let imageDot: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 2
        image.backgroundColor = DColor.blueColor
        image.clipsToBounds = true
        image.isHidden = true
        return image
    }()
    
    fileprivate var imageFillter: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_arrow_drop_down_36pt")
        imageView.backgroundColor = DColor.whiteColor
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = DColor.blackColor
        imageView.isHidden = true
        imageView.transform = CGAffineTransform(rotationAngle: 0)
        return imageView
    }()
    
    var typeInfor: TypeInfor? {
        willSet{
            self.label.text = newValue?.rawValue
            if (newValue?.checkCompulsory())! {
                self.imageDot.isHidden = false
            } else {
                self.imageDot.isHidden = true
            }
            
            if newValue == TypeInfor.phoneNumber {
                self.textField.keyboardType = .numberPad
            }
            
            if newValue == TypeInfor.city {
                self.textField.isEnabled = false
            }
            
            if newValue == TypeInfor.job {
                self.textField.isEnabled = false
            }
            
            if newValue == TypeInfor.style {
                self.imageFillter.isHidden = false
                self.textField.isEnabled = false
                self.dropDown.dataSource = self.listKind
                self.textField.text = "Tất cả"
                self.view.isUserInteractionEnabled = true
                self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showFilter)))
            }
            
            if newValue == TypeInfor.sex {
                self.imageFillter.isHidden = false
                self.textField.isEnabled = false
                self.textField.text = "Giới tính"
                self.dropDown.dataSource = self.listSex
                self.view.isUserInteractionEnabled = true
                self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showFilter)))
            }
            
            if newValue == TypeInfor.birth {
                self.imageFillter.isHidden = false
                self.textField.isEnabled = false
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                self.textField.text = formatter.string(from: date)
                self.view.isUserInteractionEnabled = true
                self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCalendar)))
            }
            
        }
    }
    
    fileprivate let dropDown = DropDown()
    fileprivate var listCategory = ["Hạng mục", "Xây dựng", "Nội thất", "Cơ điện"]
    fileprivate var listKind = ["Tất cả", "Thi công", "Mua bán", "Tìm đối tác", "Tìm thợ", "Tuyển dụng"]
    fileprivate var listSex = ["Giới tính", "Nam", "Nữ"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(label)
        self.addSubview(view)
        self.view.addSubview(textField)
        self.view.addSubview(imageFillter)
        self.addSubview(imageDot)
        
        self.textField.addTarget(self, action: #selector(textFieldDid(_:)), for: .editingDidEndOnExit)
        
        self.label.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview().offset(0)
            make.width.greaterThanOrEqualTo(30)
            make.width.lessThanOrEqualTo(100)
            make.height.equalToSuperview().multipliedBy(1.0/2.0)
        }
        
        self.view.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview().offset(0)
            make.top.equalTo(self.label.snp.bottom).offset(0)
        }
        
        self.textField.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.top.bottom.equalToSuperview().offset(0)
        }
        self.imageFillter.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.textField.snp.height).multipliedBy(1.0/2.0)
            make.centerY.equalTo(self.textField).offset(0)
            make.trailing.equalTo(self.textField.snp.trailing).offset(-5)
        }
        
        self.imageDot.snp.makeConstraints { (make) in
            make.height.width.equalTo(4)
            make.leading.equalTo(self.label.snp.trailing).offset(5)
            make.centerY.equalTo(self.label).offset(0)
        }
        
        self.dropDown.anchorView = self.textField
        self.dropDown.bottomOffset = CGPoint(x: 0, y: self.textField.bounds.height)
        self.dropDown.dataSource = self.listCategory
        self.dropDown.selectionAction = { [weak self] (index, item) in
            self?.textField.text = item
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func showFilter(){
        self.dropDown.show()
    }
    
    @objc func textFieldDid(_ textField: UITextField) {
        textField.endEditing(true)
    }
    
    @objc func showCalendar(){
        DatePickerDialog().show("Chọn ngày sinh của bạn", doneButtonTitle: "OK", cancelButtonTitle: "Huỷ", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                self.textField.text = formatter.string(from: dt)
            }
        }
    }
    
    func setData(data: String) {
        self.textField.text = data
    }
    
    func getData() -> String {
        if self.typeInfor == TypeInfor.style && self.textField.text == "Tất cả" {
            return ""
        } else if self.typeInfor == TypeInfor.job && self.textField.text == "Hạng mục" {
            return ""
        } else {
            return self.textField.text!
        }
    }
    
    func checkNilValue() -> Bool {
        if (self.typeInfor?.checkCompulsory())! && ((self.textField.text?.isEmpty)! || self.textField.text == nil || self.textField.text == "") {
            return false
        } else {
            return true
        }
    }
}

