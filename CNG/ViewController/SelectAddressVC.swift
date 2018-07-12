//
//  SelectAddressViewController.swift
//  CNG
//
//  Created by Quang on 5/15/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

class SelectAddressViewController: UIViewController {

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
        label.text = "Lọc khu vực"
        label.textColor = DColor.whiteColor
        label.font = DFont.fontBold(size: 18)
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    fileprivate var viewSearch:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.backgroundColor = DColor.whiteColor
        return view
    }()
    
    fileprivate let imageSearch: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_search")
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = DColor.blackColor
        imageView.transform = CGAffineTransform(rotationAngle: 0)
        return imageView
    }()
    
    fileprivate let labelSearch: UILabel = {
        let label = UILabel()
        label.text = "Thêm khu vực"
        label.textColor = DColor.blackOpacity85Percent
        label.font = DFont.fontLight(size: 14)
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = DColor.grayColor
        return collectionView
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
    
    fileprivate var listAddress = [AddressModel]()
    fileprivate var listAddressJobs = [AddressModel]()
    var listAddressCurrent: [AddressModel]?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    var addressSelect: ((_ address: [AddressModel]) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DColor.grayColor
        SelectAddressItemCL.registerCellByClass(self.collectionView)
        AddressCurrentItemCL.registerCellByClass(self.collectionView)
        self.collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView")
        APIManage.shared.getAddress { (sucess, listAddress) in
            if sucess {
                self.listAddress = listAddress
                for i in 1..<11 {
                    if self.listAddress.count > i{
                        self.listAddressJobs.append(self.listAddress[i])
                    }
                }
                self.collectionView.reloadData()
            }
        }
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        initSubView()
        initContrains()
        initActionView()
        
    }
    
    func initSubView() {
        self.view.addSubview(viewNav)
        self.viewNav.addSubview(viewStatusbar)
        self.viewNav.addSubview(viewNavi)
        self.viewNavi.addSubview(labelTitle)
        self.viewNavi.addSubview(imageViewBack)
        
        self.view.addSubview(viewSearch)
        self.view.addSubview(collectionView)
        self.view.addSubview(btnFillter)
        
        self.viewSearch.addSubview(imageSearch)
        self.viewSearch.addSubview(labelSearch)
        
    }
    
    func initContrains() {
        
        initContrainsNav()
        
        self.viewSearch.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalTo(self.viewNav.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        self.imageSearch.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview().offset(0)
            make.height.equalToSuperview().multipliedBy(2.0/3.0)
            make.width.equalTo(self.imageSearch.snp.height).multipliedBy(1.0/1.0)
        }
        
        self.labelSearch.snp.makeConstraints { (make) in
            make.leading.equalTo(self.imageSearch.snp.trailing).offset(15)
            make.trailing.top.bottom.equalToSuperview().offset(0)
        }
        
        self.collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().offset(0)
            make.top.equalTo(self.viewSearch.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-70)
        }
        
        self.btnFillter.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(1.0/2.0)
            make.height.equalTo(40)
            make.centerX.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(-20)
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
        self.viewSearch.isUserInteractionEnabled = true
        self.btnFillter.isUserInteractionEnabled = true
        self.btnFillter.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(back)))
        self.imageViewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(back)))
        self.viewSearch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(search)))
    }
    
    @objc func back() {
        SQLiteManger.getInstance().deleteAllData()
        for question in self.listAddressCurrent! {
            SQLiteManger.getInstance().insertAddress(address: question)
        }
        if let block = self.addressSelect {
            block(self.listAddressJobs)
        }
        self.dismiss(animated: true)
    }
    
    @objc func search() {
        let selectAddress = SelectAddress()
        selectAddress.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        selectAddress.setData(listAddress: self.listAddress, listAddressChoose: self.listAddressCurrent!)
        selectAddress.addressSelect = { (address) in
            self.listAddressCurrent = address
            self.collectionView.reloadData()
        }
        self.view.addSubview(selectAddress)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SelectAddressViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.listAddressCurrent!.count
        case 1:
            return self.listAddressJobs.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width:collectionView.frame.size.width, height:30.0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView: HeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! HeaderView
        if indexPath.section == 0 {
            headerView.label.text = "Các khu vực lưu gần đây của bạn"
        } else {
            headerView.label.text = "Danh sách 10 khu vực nhiều công việc nhất"
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = AddressCurrentItemCL.loadCell(collectionView, path: indexPath) as! AddressCurrentItemCL
            cell.setData(address: self.listAddressCurrent![indexPath.row], selectAddressDelegate: self)
            return cell
        } else {
            let cell = SelectAddressItemCL.loadCell(collectionView, path: indexPath) as! SelectAddressItemCL
            var isSelect = false
            for address in self.listAddressCurrent! {
                if address.address == self.listAddressJobs[indexPath.row].address {
                    isSelect = true
                    break
                }
            }
            cell.setData(address: self.listAddressJobs[indexPath.row], selectAddressDelegate: self, isSelect: isSelect)
            return cell
        }
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

extension SelectAddressViewController: SelectAddressDelegate{
    func selectAddress(address: AddressModel) {
        
        var isSelect = false
        for addressCurrent in self.listAddressCurrent! {
            if addressCurrent.address == address.address {
                isSelect = true
                break
            }
        }
        
        if isSelect == true{
            return
        } else {
            self.listAddressCurrent!.append(address)
            self.collectionView.reloadData()
        }
    }
    
    func didSelectAddress(address: AddressModel) {
        
        var isSelect = -1
        for i in 0..<self.listAddressCurrent!.count {
            if address.address == self.listAddressCurrent![i].address {
                isSelect = i
                break
            }
        }
        
        if isSelect != -1 {
            self.listAddressCurrent!.remove(at: isSelect)
            self.collectionView.reloadData()
        } else {
            return
        }
    }
    
}

class HeaderView: UICollectionReusableView{
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = DColor.blackColor
        label.font = DFont.fontLight(size: 16)
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.trailing.top.bottom.equalToSuperview().offset(0)
            make.leading.equalToSuperview().offset(15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
