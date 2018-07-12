//
//  SelectCategory.swift
//  CNG
//
//  Created by Quang on 5/24/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

class SelectCategory: UIView {

    fileprivate let viewContent: UIView = {
        let view = UIView()
        view.backgroundColor = DColor.whiteColor
        return view
    }()
    
    fileprivate let labelTitle: UILabel = {
        let view = UILabel()
        view.text = "CHỌN HẠNG MỤC"
        view.textColor = DColor.readColor
        view.font = DFont.fontBold(size: 18)
        view.textAlignment = NSTextAlignment.center
        return view
    }()
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = DColor.whiteColor
        return collectionView
    }()
    
    fileprivate var btnOk: UILabel = {
        let view = UILabel()
        view.text = "OK"
        view.textColor = DColor.readColor
        view.font = DFont.fontBold(size: 18)
        view.textAlignment = .center
        return view
    }()
    
    fileprivate var btnCancel: UILabel = {
        let view = UILabel()
        view.text = "Cancel"
        view.textColor = DColor.blackColor
        view.font = DFont.fontLight(size: 18)
        view.textAlignment = .center
        return view
    }()
    var categorySelect: ((_ category: [String]) -> ())?
    fileprivate var listCategory = [String]()
    fileprivate var listCategoryCurrent: [String]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = DColor.blackOpacity15Percent
        SelectCategoryInforItemCL.registerCellByClass(self.collectionView)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.addSubview(viewContent)
        self.viewContent.addSubview(labelTitle)
        self.viewContent.addSubview(collectionView)
        self.viewContent.addSubview(btnOk)
        self.viewContent.addSubview(btnCancel)
        
        self.viewContent.snp.makeConstraints { (make) in
            make.center.equalToSuperview().offset(0)
            make.width.equalToSuperview().multipliedBy(5.0/6.0)
            make.height.equalTo(200)
        }
        
        self.labelTitle.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(0)
            make.height.equalTo(40)
        }
        
        self.btnOk.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(30)
            make.width.equalTo(50)
        }
        
        self.btnCancel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.trailing.equalTo(self.btnOk.snp.leading).offset(-15)
            make.height.equalTo(30)
            make.width.greaterThanOrEqualTo(50)
            make.width.lessThanOrEqualTo(120)
        }
        
        self.collectionView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(self.labelTitle.snp.bottom).offset(10)
            make.bottom.equalTo(self.btnOk.snp.top).offset(-10)
        }
     
        self.btnOk.isUserInteractionEnabled = true
        self.btnOk.addTapGesture(target: self, selector: #selector(didTouchOK))
        self.btnCancel.isUserInteractionEnabled = true
        self.btnCancel.addTapGesture(target: self, selector: #selector(didTouchCancel))
        
    }
    
    @objc func didTouchOK()  {
        if let block = categorySelect {
            block(self.listCategoryCurrent!)
        }
        didTouchCancel()
    }
    
    @objc func didTouchCancel()  {
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: self.size.width, height: self.size.height)
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(listCategory: [String], listCategoryCurrent: [String]){
        self.listCategory = listCategory
        self.listCategoryCurrent = listCategoryCurrent
        self.collectionView.reloadData()
    }
    
}

extension SelectCategory: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = SelectCategoryInforItemCL.loadCell(collectionView, path: indexPath) as! SelectCategoryInforItemCL
        var isSelect = false
        for category in self.listCategoryCurrent! {
            if category == self.listCategory[indexPath.row]{
                isSelect = true
                break
            }
        }
        cell.setData(category: self.listCategory[indexPath.row], selectCategoryDelegate: self, isSelect: isSelect)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

extension SelectCategory: SelectCategoryInforDelegate{
    
    func selectCategory(category: String) {
        var isSelect = false
        for categoryCurrent in self.listCategoryCurrent! {
            if category == categoryCurrent {
                isSelect = true
                break
            }
        }
        
        if isSelect == true{
            return
        } else {
            self.listCategoryCurrent!.append(category)
            self.collectionView.reloadData()
        }
    }
    
    func didSelectCategory(category: String) {
        
        var isSelect = -1
        for i in 0..<self.listCategoryCurrent!.count {
            if category == self.listCategoryCurrent![i] {
                isSelect = i
                break
            }
        }
        
        if isSelect != -1 {
            self.listCategoryCurrent!.remove(at: isSelect)
            self.collectionView.reloadData()
        } else {
            return
        }
    }
    
}

protocol SelectCategoryInforDelegate {
    func selectCategory(category: String)
    func didSelectCategory(category: String)
}

class SelectCategoryInforItemCL: BaseCollectionCell {
    
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
    
    var selectCategoryDelegate: SelectCategoryInforDelegate?
    var category: String?
    
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
    
    func setData(category: String, selectCategoryDelegate: SelectCategoryInforDelegate, isSelect: Bool) {
        self.category = category
        self.label.text = "\((self.category)!)"
        self.checkBox.isSelected = isSelect
        self.selectCategoryDelegate = selectCategoryDelegate
    }
}

