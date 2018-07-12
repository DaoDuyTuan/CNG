//
//  AddViewController.swift
//  CNG
//
//  Created by Quang on 5/29/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

protocol SelectAddressForAddDelegate {
    func selectAddress(address: [AddressModel])
}

class AddViewController: UIViewController {

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
        label.text = "Chọn bài viết"
        label.textColor = DColor.whiteColor
        label.font = DFont.fontLight(size: 18)
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    fileprivate let viewContent: UIView = {
        let view = UIView()
        view.backgroundColor = DColor.grayColor
        return view
    }()
    
    fileprivate var viewBottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = DColor.readColor
        return view
    }()
    
    fileprivate var stepView: StepView = {
        let slider = StepView()
        slider.setStep(step: Step.dashboard)
        return slider
    }()
    
    fileprivate var nextStepView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ic_keyboard_arrow_right_36pt")
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = UIColor.white
        view.isHidden = true
        return view
    }()
    
    fileprivate var postJobView: PostedJobs = {
        let post = PostedJobs()
        post.isHidden = false
        return post
    }()
    
    fileprivate var selectAddressForPostJobView: SelectAddressForPostJobView = {
        let selectAddressForPostJobView = SelectAddressForPostJobView()
        selectAddressForPostJobView.isHidden = true
        return selectAddressForPostJobView
    }()
    
    fileprivate var selectCategoryForPostJobView: SelectCategoryForPostJobView = {
        let selectCategoryForPostJobView = SelectCategoryForPostJobView()
        selectCategoryForPostJobView.isHidden = true
        return selectCategoryForPostJobView
    }()
    
    var backBlock: (() -> ())?
    
    fileprivate var message: String?
    fileprivate var category_id = 0
    fileprivate var job_id = 0
    fileprivate var listAddressCurrent = [AddressModel]()
    fileprivate var listImage = [UIImage]()
    
    var step: Step? {
        willSet{
            self.stepView.setStep(step: newValue!)
            self.postJobView.isHidden = true
            self.selectCategoryForPostJobView.isHidden = true
            self.selectAddressForPostJobView.isHidden = true
            switch newValue {
            case .dashboard?:
                self.postJobView.isHidden = false
                self.nextStepView.isHidden = true
                self.nextStepView.image = UIImage(named: "ic_keyboard_arrow_right_36pt")
                self.nextStepView.image = self.nextStepView.image!.withRenderingMode(.alwaysTemplate)
                view.tintColor = UIColor.white
                self.labelTitle.text = "Chọn bài viết"
                break
            case .group?:
                self.selectCategoryForPostJobView.isHidden = false
                self.labelTitle.text = "Đối tượng"
                self.nextStepView.isHidden = false
                self.nextStepView.image = UIImage(named: "ic_keyboard_arrow_right_36pt")
                self.nextStepView.image = self.nextStepView.image!.withRenderingMode(.alwaysTemplate)
                view.tintColor = UIColor.white
                break
            case .area?:
                self.selectAddressForPostJobView.isHidden = false
                self.labelTitle.text = "Khu vực"
                self.nextStepView.isHidden = false
                self.nextStepView.image = UIImage(named: "ic_check_3x")
                self.nextStepView.image = self.nextStepView.image!.withRenderingMode(.alwaysTemplate)
                view.tintColor = UIColor.white
                break
            default :
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.view.backgroundColor = DColor.grayColor
        self.step = Step.dashboard
        self.selectAddressForPostJobView.selectAddressForAddDelegate = self
        addSubView()
        initContrains()
        initActionView()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.postJobView.reloadPosted()
    }
    
    fileprivate func addSubView() {
        self.view.addSubview(viewNavigationBar)
        self.view.addSubview(viewContent)
        self.view.addSubview(viewBottomBar)
        
        self.viewNavigationBar.addSubview(imageBack)
        self.viewNavigationBar.addSubview(labelTitle)
        
        self.viewContent.addSubview(postJobView)
        self.viewContent.addSubview(selectAddressForPostJobView)
        self.viewContent.addSubview(selectCategoryForPostJobView)
        
        self.viewBottomBar.addSubview(stepView)
        self.viewBottomBar.addSubview(nextStepView)
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
        
        self.labelTitle.snp.makeConstraints { (make) in
            make.leading.equalTo(self.imageBack.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(0)
            make.centerY.equalTo(self.imageBack).offset(0)
            make.height.equalTo(self.imageBack).multipliedBy(1.0/1.0)
        }
        
        self.viewBottomBar.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().offset(0)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(UIDevice.tabbar.rawValue - 48)
        }
        
        self.stepView.snp.makeConstraints { (make) in
            make.center.equalToSuperview().offset(0)
            make.width.equalToSuperview().multipliedBy(1.0/2.0)
            make.height.equalToSuperview().multipliedBy(1.0/1.0)
        }
        
        self.nextStepView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(0)
            make.height.equalToSuperview().multipliedBy(2.0/3.0)
            make.width.equalTo(self.nextStepView.snp.height).multipliedBy(1.0/1.0)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        self.viewContent.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().offset(0)
            make.top.equalTo(self.viewNavigationBar.snp.bottom).offset(0)
            make.bottom.equalTo(self.viewBottomBar.snp.top).offset(0)
        }
        
        self.postJobView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview().offset(0)
        }
        
        self.selectAddressForPostJobView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview().offset(0)
        }
        
        self.selectCategoryForPostJobView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview().offset(0)
        }
        
    }
    
    func initActionView() {
        self.postJobView.createJob = self
        self.imageBack.isUserInteractionEnabled = true
        self.imageBack.addTapGesture(target: self, selector: #selector(back))
        self.nextStepView.isUserInteractionEnabled = true
        self.nextStepView.addTapGesture(target: self, selector: #selector(nextStep))
        
    }
    
    @objc func back() {
        switch self.step {
        case .dashboard?:
            if let block = backBlock {
                block()
            }
            break
        case .group?:
            self.step = Step.dashboard
            break
        case .area?:
            self.step = Step.group
            break
        default :
            break
        }
    }
    
    @objc func nextStep() {
        switch self.step {
        case .dashboard?:
            self.step = Step.group
            break
        case .group?:
            self.step = Step.area
            break
            if category_id == 0 || job_id == 0 {
                break
            } else {
                self.step = Step.area
                break
            }
        case .area?:
            if self.listAddressCurrent.count == 0{
                break
            } else {
                break
            }
        default :
            break
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension AddViewController: CreateJob {
    func createJob() {
//        let createPostJobView = CreatePostJobView()
//        createPostJobView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
//        createPostJobView.createJobActionDelegate = self
//        createPostJobView.nextStep = { (content) in
//            if content != "" || content.isEmpty == false {
//                self.step = Step.group
//                self.message = content
//            }
//        }
//        self.view.addSubview(createPostJobView)
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "postScreen")
        postJob = PostModel()
        postJob.img = ([], [])
        postJob.message = ""
        self.present(vc, animated: true, completion: nil)
    }
}

extension AddViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RequestViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension AddViewController: SelectAddressForAddDelegate {
    func selectAddress(address: [AddressModel]) {
        self.listAddressCurrent = address
        print(self.listAddressCurrent.count)
    }
}

extension AddViewController: CreateJobActionDelegate {
    func selectImageAction() {
        self.selectImage()
    }
    
    func selectCameraAction() {
        
    }
    
}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    fileprivate func selectImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            listImage.append(pickedImage)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
