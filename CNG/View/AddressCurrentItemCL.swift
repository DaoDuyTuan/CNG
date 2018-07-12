//
//  AddressCurrentItemCL.swift
//  CNG
//
//  Created by Quang on 5/15/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

class AddressCurrentItemCL: BaseCollectionCell {
    
    fileprivate var label: UILabel = {
        let view = UILabel()
        view.textColor = DColor.blackColor
        view.font = DFont.fontLight(size: 18)
        view.textAlignment = NSTextAlignment.left
        return view
    }()
    
    fileprivate var imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = DColor.readColor
        view.image = UIImage(named: "ic_highlight_off_white")
        view.layer.cornerRadius = 10
        return view
    }()
    
    var selectAddressDelegate: SelectAddressDelegate?
    var addressModel: AddressModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageView)
        self.addSubview(label)
        
        self.imageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview().offset(0)
            make.height.equalToSuperview().multipliedBy(1.0/2.0)
            make.width.equalTo(self.imageView.snp.height).multipliedBy(1.0/1.0)
        }
        
        self.label.snp.makeConstraints { (make) in
            make.leading.equalTo(self.imageView.snp.trailing).offset(15)
            make.top.bottom.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(-10)
        }
        self.imageView.isUserInteractionEnabled = true
        self.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteItem)))
    }
    
    @objc func deleteItem() {
        selectAddressDelegate?.didSelectAddress(address: self.addressModel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(address: AddressModel, selectAddressDelegate: SelectAddressDelegate) {
        self.addressModel = address
        self.label.text = "\((self.addressModel?.address)!)(\((self.addressModel?.countJob)!))"
        self.selectAddressDelegate = selectAddressDelegate
    }
}
