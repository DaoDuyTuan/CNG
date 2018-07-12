//
//  SelectCategoryVC.swift
//  CNG
//
//  Created by Quang on 5/15/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

class SelectCategoryVC: UIViewController {
    
    fileprivate let viewNav: UIView = {
        let view = UIView()
        
        return view
    }()
    fileprivate let imageViewBack: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "ic_arrow_back_white"), for: .normal)
        return button
    }()
    
    fileprivate let viewStatusbar: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate let viewNavi: UIView = {
        let view = UIView()
        view.backgroundColor = DColor.readColor
        return view
    }()
    
    fileprivate let labelTitle: UILabel = {
        let label = UILabel()
        label.text = "Lọc theo hạng mục"
        label.textColor = DColor.whiteColor
        label.font = DFont.fontBold(size: 18)
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    fileprivate let btnFillter: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 3
        button.setTitle("LỌC KẾT QUẢ", for: .normal)
        button.backgroundColor = DColor.readColor
        button.clipsToBounds = true
        button.titleLabel?.font = DFont.fontBold(size: 16)
        button.titleLabel?.textColor = DColor.whiteColor
        return button
    }()
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = DColor.grayColor
        return collectionView
    }()

    fileprivate var listCategory = [Category]()
    var listCategoryCurrent: [String]?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    fileprivate var listAddress: [AddressModel] = SQLiteManger.getInstance().getListAddress()
    var categorySelect: ((_ category: [String]) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DColor.grayColor
        SelectCategoryItemCL.registerCellByClass(self.collectionView)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        initSubView()
        initContrains()
        initActionView()
        
        print(self.listAddress.count, self.listAddress)
        
        APIManage.shared.getCategory(address: self.listAddress) { (sucess, listCategory) in
            self.listCategory = listCategory
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func initSubView() {
        self.view.addSubview(viewNav)
        self.view.addSubview(btnFillter)
        self.view.addSubview(collectionView)
        self.viewNav.addSubview(viewStatusbar)
        self.viewNav.addSubview(viewNavi)
        self.viewNavi.addSubview(labelTitle)
        self.viewNavi.addSubview(imageViewBack)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    func initContrains() {
        
        initContrainsNav()
        
        self.btnFillter.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(1.0/2.0)
            make.height.equalTo(40)
            make.centerX.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        self.collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().offset(0)
            make.top.equalTo(self.viewNav.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-70)
        }
        
    }
    
    func initContrainsNav() {
        self.viewNav.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview().offset(0)
            make.height.equalTo(UIDevice.statusBar.rawValue + 44)
        }
        
        self.viewStatusbar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview().offset(0)
            make.height.equalTo(UIDevice.statusBar.rawValue)
        }
        
        self.viewNavi.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().offset(0)
            make.top.equalTo(self.viewStatusbar.snp.bottom).offset(0)
            make.height.equalTo(44)
        }
        
        self.imageViewBack.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(0)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo((self.imageViewBack.snp.height)).multipliedBy(1.0/1.0)
        }
        
        self.labelTitle.snp.makeConstraints { (make) in
            make.trailing.top.bottom.equalToSuperview().offset(0)
            make.leading.equalTo(self.imageViewBack.snp.trailing).offset(15)
        }
    }
    
    func initActionView() {
        self.imageViewBack.isUserInteractionEnabled = true
        self.btnFillter.isUserInteractionEnabled = true
        self.btnFillter.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(back)))
        self.imageViewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(back)))
    }
    
    @objc func back() {
        SQLiteManger.getInstance().deleteAllDataCategory()
        for question in self.listCategoryCurrent! {
            SQLiteManger.getInstance().insertCategory(category: question)
        }
        if let block = self.categorySelect {
            block(self.listCategoryCurrent!)
        }
        
        self.dismiss(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension SelectCategoryVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = SelectCategoryItemCL.loadCell(collectionView, path: indexPath) as! SelectCategoryItemCL
        var isSelect = false
        for category in self.listCategoryCurrent! {
            if category == self.listCategory[indexPath.row].category_name {
                isSelect = true
                break
            }
        }
        cell.setData(category: self.listCategory[indexPath.row], selectCategoryDelegate: self, isSelect: isSelect)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width/2 - 20, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

extension SelectCategoryVC: SelectCategoryDelegate{
    
    func selectCategory(category: Category) {
        var isSelect = false
        for categoryCurrent in self.listCategoryCurrent! {
            if category.category_name == categoryCurrent {
                isSelect = true
                break
            }
        }
        
        if isSelect == true{
            return
        } else {
            self.listCategoryCurrent!.append(category.category_name!)
            self.collectionView.reloadData()
        }
    }
    
    func didSelectCategory(category: Category) {
        
        var isSelect = -1
        for i in 0..<self.listCategoryCurrent!.count {
            if category.category_name == self.listCategoryCurrent![i] {
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
