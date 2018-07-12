//
//  JobItemTableViewCell.swift
//  CNG
//
//  Created by Quang on 05/05/2018.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

enum TypeActionView{
    case message
    case call
    case favorite
    
    func image() -> String {
        switch self {
        case .message:
            return "iTunesArtwork-3"
        case .call:
            return "iTunesArtwork"
        case .favorite:
            return "iTunesArtwork-2"
        }
    }
    
    func title() -> String {
        switch self {
        case .message:
            return "Chi tiết"
        case .call:
            return "Gọi điện"
        case .favorite:
            return "Lưu"
        }
    }
    
}

protocol SelectAction {
    func actionDetail(job: JobModel, index: Int)
    func actionCall(job: JobModel, index: Int)
    func actionFavorite(job: JobModel, index: Int)
    func actionDelete(job: JobModel)
    func actionMessage(job: JobModel, index: Int)
    func actionShare(job: JobModel, index: Int)
    func actionLongClick(job: JobModel, index: Int)
}

class JobItemTableViewCell: MyJobCell {

    fileprivate var labelName: UILabel = {
        let view = UILabel()
        view.textColor = DColor.blackColor
        view.font = DFont.fontBold(size: 16)
        view.textAlignment = NSTextAlignment.left
        return view
    }()
    
    fileprivate var labelCountFavorite: UILabel = {
        let view = UILabel()
        view.textColor = DColor.blackColor
        view.font = DFont.fontLight(size: 12)
        view.textAlignment = NSTextAlignment.left
        return view
    }()
    
    fileprivate var imageViewMessage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ic_message")
        return view
    }()
    
    fileprivate var imageViewShare: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ic_share_job")
        return view
    }()
    
    fileprivate var labelDate: UILabel = {
        let view = UILabel()
        view.textColor = DColor.blackOpacity85Percent
        view.font = DFont.fontLight(size: 12)
        view.textAlignment = NSTextAlignment.left
        return view
    }()
    
    fileprivate var labelContent: UILabel = {
        let view = UILabel()
        view.textColor = DColor.blackColor
        view.font = DFont.fontLight(size: 16)
        view.textAlignment = NSTextAlignment.left
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0
        return view
    }()
    
//    fileprivate var imageJob: UIImageView = {
//        let image = UIImageView()
//        image.contentMode = .scaleToFill
//        return image
//    }()
    
    fileprivate var imageJob: UIView = {
        let image = UIView()
//        image.contentMode = .scaleToFill
        return image
    }()
    fileprivate var actionView: UIView = {
        let view = UIView()
        view.backgroundColor = DColor.whiteColor
        return view
    }()
    
    fileprivate var actionDetail: ActionView = {
        let view = ActionView()
        view.setType(type: TypeActionView.message)
        return view
    }()
    
    fileprivate var actionCall: ActionView = {
        let view = ActionView()
        view.setType(type: TypeActionView.call)
        return view
    }()
    
    fileprivate var actionFavorite: ActionView = {
        let view = ActionView()
        view.setType(type: TypeActionView.favorite)
        return view
    }()
    
    fileprivate var job: JobModel?{
        willSet{
            if newValue?.phoneNumber == nil {
                self.actionCall.isHidden = true
            }
        }
    }
    fileprivate var selectAction: SelectAction?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        print(self.contentView.frame.height)
        
        self.addSubview(labelName)
        self.addSubview(labelCountFavorite)
        self.addSubview(imageViewMessage)
        self.addSubview(imageViewShare)
        self.addSubview(labelDate)
        self.addSubview(actionView)
        self.addSubview(imageJob)
        self.addSubview(labelContent)
        
        self.actionView.addSubview(actionDetail)
        self.actionView.addSubview(actionCall)
        self.actionView.addSubview(actionFavorite)
        
        initContrains()
        
        self.isUserInteractionEnabled = true
        self.imageViewMessage.isUserInteractionEnabled = true
        self.imageViewShare.isUserInteractionEnabled = true
        self.actionDetail.isUserInteractionEnabled = true
        self.actionCall.isUserInteractionEnabled = true
        self.actionFavorite.isUserInteractionEnabled = true
        
//        self.imageViewMessage.addTapGesture(target: self, selector: #selector(messageClick))
//        self.imageViewShare.addTapGesture(target: self, selector: #selector(shareClick))
//        self.actionDetail.addTapGesture(target: self, selector: #selector(detailClick))
//        self.actionCall.addTapGesture(target: self, selector: #selector(callClick))
//        self.actionFavorite.addTapGesture(target: self, selector: #selector(favorieClick))
//        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longClick)))
    }
    
    func initContrains() {
        self.labelName.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(20)
            make.width.greaterThanOrEqualTo(30)
            make.width.lessThanOrEqualTo(200)
        }
        
        self.labelCountFavorite.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.labelName).offset(0)
            make.height.equalTo(self.labelName.snp.height).multipliedBy(1.0/1.0)
            make.width.greaterThanOrEqualTo(30)
            make.width.lessThanOrEqualTo(150)
            make.leading.equalTo(self.labelName.snp.trailing).offset(5)
        }
        
        self.imageViewMessage.snp.makeConstraints { (make) in
            make.width.height.equalTo(25)
            make.centerY.equalTo(self.labelName).offset(0)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        self.imageViewShare.snp.makeConstraints { (make) in
            make.width.height.equalTo(25)
            make.centerY.equalTo(self.labelName).offset(0)
            make.trailing.equalTo(self.imageViewMessage.snp.leading).offset(-20)
        }
        
        self.labelDate.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.width.greaterThanOrEqualTo(30)
            make.width.lessThanOrEqualTo(300)
            make.top.equalTo(self.labelName.snp.bottom).offset(5)
            make.height.equalTo(15)
        }
        
        self.actionView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview().offset(0)
            make.height.equalTo(40)
        }
        
        self.labelContent.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalTo(self.labelDate.snp.bottom).offset(0)
            make.bottom.equalTo(self.actionView.snp.top).offset(-5)
        }
        
        self.actionDetail.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalToSuperview().offset(0)
            make.width.equalToSuperview().multipliedBy(1.0/3.0)
        }
        
        self.actionFavorite.snp.makeConstraints { (make) in
            make.trailing.top.bottom.equalToSuperview().offset(0)
            make.width.equalToSuperview().multipliedBy(1.0/3.0)
        }
        self.actionCall.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().offset(0)
            make.leading.equalTo(self.actionDetail.snp.trailing).offset(0)
            make.trailing.equalTo(self.actionFavorite.snp.leading).offset(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    @objc func messageClick() {
//        addApproach(job: self.job!)
//        self.selectAction?.actionMessage(job: self.job!)
//    }
//
//    @objc func shareClick() {
//        addApproach(job: self.job!)
//        self.selectAction?.actionShare(job: self.job!)
//    }
//
//    @objc func detailClick() {
//        addApproach(job: self.job!)
//        self.selectAction?.actionDetail(job: self.job!)
//    }
//
//    @objc func callClick() {
//        addApproach(job: self.job!)
////        self.selectAction?.actionCall(job: self.job!, atJob: self.lb)
//    }
//
//    @objc func favorieClick() {
//        addApproach(job: self.job!)
//        self.selectAction?.actionFavorite(job: self.job!)
//    }
//
//    @objc func longClick() {
//        addApproach(job: self.job!)
//        self.selectAction?.actionLongClick(job: self.job!)
//    }
//
//    func addApproach(job: JobModel) {
//        APIManage.shared.addApproach(idJob: "\((job.oder_id!))", idUser: (UserModel(data: UserModel.userCache!).id)!) { (success, count_approach) in
//            if success {
//                self.job?.count_approach = count_approach
//                self.labelCountFavorite.text = "(\(job.count_approach != nil ? job.count_approach! : 0) người tiếp cận )"
//            }
//        }
//    }
    
    func setData(job: JobModel, selectAction: SelectAction, isImage: Bool) {
        self.job = job
        self.selectAction = selectAction
        self.labelName.text = job.postBy
        self.labelContent.text = job.message
        if job.phoneNumber == "Null"{
            self.actionCall.isHidden = true
        } else {
            self.actionCall.isHidden = false
        }
        if isImage {
            if self.job?.image != nil {
                self.labelContent.snp.removeConstraints()
                self.labelContent.snp.makeConstraints { (make) in
                    make.leading.equalToSuperview().offset(15)
                    make.trailing.equalToSuperview().offset(-15)
                    make.top.equalTo(self.labelDate.snp.bottom).offset(0)
                    make.height.equalTo(heightForLabel(text: (self.job?.message)!, font: DFont.fontLight(size: 16), width: UIScreen.main.bounds.size.width - 30))
                    self.layoutIfNeeded()
                }
                
                self.imageJob.snp.makeConstraints { (make) in
                    make.leading.equalToSuperview().offset(15)
                    make.trailing.equalToSuperview().offset(-10)
                    make.top.equalTo(self.labelContent.snp.bottom).offset(5)
                    make.bottom.equalTo(self.actionView.snp.top).offset(-5)
                    self.layoutIfNeeded()
                }
                
                let url = "http://150.95.109.183:3000/upload/"
                
                let images = self.job?.image!.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").split(separator: ",")
                var xOfImage: CGFloat = 0
                for src in (images)! {
                    let image = UIImageView(frame: CGRect(x: xOfImage, y: 0, width: self.contentView.width * 0.3, height: self.imageJob.frame.height))
                    image.sd_setImage(with: URL(string: url + String(src)), completed: nil)
                    self.imageJob.addSubview(image)
                    xOfImage += image.frame.width + 4
                }
            }
        }
        
        self.labelCountFavorite.text = "(\(job.count_approach != nil ? job.count_approach! : 0) người tiếp cận )"
        
        if job.isLoadFromFirbase {
            self.labelDate.text = "\(job.postDate!)  \((job.address)!) \((job.category_name)!) \((job.job_name)!)"
        } else {
            self.labelDate.text = "\(formatDate(date: job.postDate!))  \((job.address)!) \((job.category_name)!) \((job.job_name)!)"
        }
    }
    
    func formatDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateCutrent = dateFormatter.date(from: date)
        let day = Calendar.current.component(.day, from: dateCutrent!) < 10 ? "0\(Calendar.current.component(.day, from: dateCutrent!))" : "\(Calendar.current.component(.day, from: dateCutrent!))"
        let month = Calendar.current.component(.month, from: dateCutrent!) < 10 ? "0\(Calendar.current.component(.month, from: dateCutrent!))" : "\(Calendar.current.component(.month, from: dateCutrent!))"
        let year = Calendar.current.component(.year, from: dateCutrent!)
        let hour = Calendar.current.component(.hour, from: dateCutrent!) < 10 ? "0\(Calendar.current.component(.hour, from: dateCutrent!))" : "\(Calendar.current.component(.hour, from: dateCutrent!))"
        let minute = Calendar.current.component(.minute, from: dateCutrent!) < 10 ? "0\(Calendar.current.component(.minute, from: dateCutrent!))" : "\(Calendar.current.component(.minute, from: dateCutrent!))"
        return "\(day)-\(month)-\(year) \(hour):\(minute)"
    }
}

class ActionView: UIView {
    
    fileprivate var image: UIImageView = {
        let view = UIImageView()
        
        return view
    }()
    
    fileprivate var label: UILabel = {
        let view = UILabel()
        view.textColor = DColor.blackColor
        view.font = DFont.fontLight(size: 14)
        view.textAlignment = NSTextAlignment.center
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = DColor.whiteColor
        self.layer.borderWidth = 1
        self.layer.borderColor = DColor.grayColor.cgColor
        self.addSubview(image)
        self.addSubview(label)
        
        self.image.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview().offset(0)
            make.height.equalToSuperview().multipliedBy(1.0/2.0)
            make.width.equalTo(self.image.snp.height).multipliedBy(1.0/1.0)
        }
        self.label.snp.makeConstraints { (make) in
            make.trailing.top.bottom.equalToSuperview().offset(0)
            make.leading.equalTo(self.image.snp.trailing).offset(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setType(type: TypeActionView){
        self.label.text = type.title()
        self.image.image = UIImage(named: type.image())
    }
    
    func setType(type: TypeActionViewFavotite){
        self.label.text = type.title()
        self.image.image = UIImage(named: type.image())
    }
    
    func setChoose() {
        self.image.image = self.image.image!.withRenderingMode(.alwaysTemplate)
        self.image.tintColor = DColor.readColor
    }
    
}
