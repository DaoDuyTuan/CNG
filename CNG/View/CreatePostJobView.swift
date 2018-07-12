//
//  CreatePostJobView.swift
//  CNG
//
//  Created by Quang on 6/9/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

protocol CreateJobActionDelegate {
    func selectImageAction()
    func selectCameraAction()
}

class CreatePostJobView: UIView {

    fileprivate var viewNavigationBar: UIView = {
        let view = UIView()
        view.backgroundColor = DColor.readColor
        return view
    }()
    
    fileprivate var imageBack: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "ic_arrow_back_white")
        return image
    }()
    
    fileprivate var labelTitle: UILabel = {
        let label = UILabel()
        label.text = "Đăng với tư cách \(UserModel(data: UserModel.userCache!).name!)"
        label.textColor = DColor.whiteColor
        label.font = DFont.fontLight(size: 18)
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    fileprivate var labelNext: UILabel = {
        let label = UILabel()
        label.text = "Tiếp"
        label.textColor = DColor.whiteColor
        label.font = DFont.fontLight(size: 18)
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    fileprivate var viewContent: UIView = {
        let view = UIView()
        
        return view
    }()
    
    fileprivate var imageAvatar: UIImageView = {
        let view = UIImageView()
        view.sd_setImage(with: URL(string: "https://graph.facebook.com//\((UserModel(data: UserModel.userCache!).id)!)/picture?type=large"), completed: { (image, erroe, type, url) in
        })
        view.layer.cornerRadius = 35
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate let labelName: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.font = DFont.fontBold(size: 16)
        view.textColor = DColor.blackColor
        view.text = UserModel(data: UserModel.userCache!).name
        return view
    }()

    fileprivate let textView: UITextView = {
        let view = UITextView()
        view.font = DFont.fontLight(size: 16)
        view.textColor = DColor.blackColor
        return view
    }()
    
    fileprivate let viewBottomBar: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = DColor.grayColor.cgColor
        return view
    }()
    
    fileprivate let imgCamera: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "photo-camera")
        return view
    }()
    
    fileprivate let imgAddImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "gallery")
        return view
    }()
    
    fileprivate let labelAddImage: UILabel = {
        let view = UILabel()
        view.text = "Thêm vào bài viết của bạn"
        view.textColor = DColor.blackColor
        view.font = DFont.fontLight(size: 18)
        view.textAlignment = NSTextAlignment.left
        return view
    }()
    
    var nextStep: ((_ content: String) -> ())?
    var createJobActionDelegate: CreateJobActionDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = DColor.whiteColor
        addSubView()
        initContrains()
        initActionView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func addSubView() {
        self.addSubview(viewNavigationBar)
        self.addSubview(viewContent)
        self.addSubview(viewBottomBar)
        
        self.viewNavigationBar.addSubview(imageBack)
        self.viewNavigationBar.addSubview(labelTitle)
        self.viewNavigationBar.addSubview(labelNext)
        
        self.viewContent.addSubview(imageAvatar)
        self.viewContent.addSubview(labelName)
        self.viewContent.addSubview(textView)
        
        self.viewBottomBar.addSubview(imgAddImage)
        self.viewBottomBar.addSubview(imgCamera)
        self.viewBottomBar.addSubview(labelAddImage)
    }
    
    fileprivate func initContrains(){
        
        self.viewNavigationBar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview().offset(0)
            make.height.equalTo(UIDevice.statusBar.rawValue + 44)
        }
        
        self.imageBack.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(UIDevice.statusBar.rawValue + 5)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        
        self.labelNext.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalTo(self.imageBack).offset(0)
            make.height.equalTo(self.imageBack).multipliedBy(1.0/1.0)
            make.width.equalTo(40)
        }
        
        self.labelTitle.snp.makeConstraints { (make) in
            make.leading.equalTo(self.imageBack.snp.trailing).offset(10)
            make.trailing.equalTo(self.labelNext.snp.leading).offset(-10)
            make.centerY.equalTo(self.imageBack).offset(0)
            make.height.equalTo(self.imageBack).multipliedBy(1.0/1.0)
        }
        
        self.viewBottomBar.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().offset(0)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(UIDevice.tabbar.rawValue - 48)
        }
        
        self.imgAddImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalToSuperview().multipliedBy(1.0/2.0)
            make.width.equalTo(self.imgAddImage.snp.height).multipliedBy(1.0/1.0)
        }
        
        self.imgCamera.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(0)
            make.trailing.equalTo(self.imgAddImage.snp.leading).offset(-20)
            make.height.equalToSuperview().multipliedBy(1.0/2.0)
            make.width.equalTo(self.imgAddImage.snp.height).multipliedBy(1.0/1.0)
        }
        
        self.labelAddImage.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.top.bottom.equalToSuperview().offset(0)
            make.trailing.equalTo(self.imgCamera.snp.leading).offset(-20)
        }
        
        self.viewContent.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.viewNavigationBar.snp.bottom).offset(0)
            make.bottom.equalTo(self.viewBottomBar.snp.top).offset(0)
        }
        
        self.imageAvatar.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(70)
            make.width.equalTo(70)
        }
        
        self.labelName.snp.makeConstraints { (make) in
            make.leading.equalTo(self.imageAvatar.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.height.greaterThanOrEqualTo(70)
            make.height.lessThanOrEqualTo(200)
        }
        
        self.textView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
            make.top.equalTo(self.labelName.snp.bottom).offset(10)
        }
        
    }
    
    func initActionView() {
        self.imageBack.isUserInteractionEnabled = true
        self.imageBack.addTapGesture(target: self, selector: #selector(didTouchCancel))
        self.imgAddImage.isUserInteractionEnabled = true
        self.imgAddImage.addTapGesture(target: self, selector: #selector(chooseImage))
        self.labelNext.isUserInteractionEnabled = true
        self.labelNext.addTapGesture(target: self, selector: #selector(didTouchOK))
    }
    
    @objc func didTouchOK()  {
        if let block = nextStep {
            block(self.textView.text.trimSpace())
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
    
    @objc func chooseImage()  {
        if createJobActionDelegate != nil {
            createJobActionDelegate?.selectImageAction()
        }
    }
    
}
