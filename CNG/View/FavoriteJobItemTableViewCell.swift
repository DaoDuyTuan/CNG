//
//  FavoriteJobItemTableViewCell.swift
//  CNG
//
//  Created by Quang on 5/9/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

enum TypeActionViewFavotite{
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
            return "iTunesArtwork-1"
        }
    }
    
    func title() -> String {
        switch self {
        case .message:
            return "Chi tiết"
        case .call:
            return "Gọi điện"
        case .favorite:
            return "Xoá"
        }
    }
}

protocol SelectActionFavorite {
    func actionDetail(job: JobModel)
    func actionCall(job: JobModel)
    func actionDelete(job: JobModel)
    func actionMessage(job: JobModel)
    func actionShare(job: JobModel)
    func actionLongClick(job: JobModel)
}

class FavoriteJobItemTableViewCell: BaseTableCell {
    
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
    
    fileprivate var imageJob: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        return image
    }()
    
    fileprivate var actionView: UIView = {
        let view = UIView()
        view.backgroundColor = DColor.whiteColor
        return view
    }()
    
    fileprivate var actionDetail: ActionView = {
        let view = ActionView()
        view.setType(type: TypeActionViewFavotite.message)
        return view
    }()
    
    fileprivate var actionCall: ActionView = {
        let view = ActionView()
        view.setType(type: TypeActionViewFavotite.call)
        return view
    }()
    
    fileprivate var actionFavorite: ActionView = {
        let view = ActionView()
        view.setType(type: TypeActionViewFavotite.favorite)
        return view
    }()
    
    fileprivate var job: JobModel?{
        willSet{
            if newValue?.phoneNumber == nil {
                self.actionCall.isHidden = true
            }
        }
    }
    fileprivate var selectAction: SelectActionFavorite?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        
        self.imageViewMessage.addTapGesture(target: self, selector: #selector(messageClick))
        self.imageViewShare.addTapGesture(target: self, selector: #selector(shareClick))
        self.actionDetail.addTapGesture(target: self, selector: #selector(detailClick))
        self.actionCall.addTapGesture(target: self, selector: #selector(callClick))
        self.actionFavorite.addTapGesture(target: self, selector: #selector(favorieClick))
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longClick)))
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
            make.trailing.equalToSuperview().offset(-20)
        }
        
        self.imageViewShare.snp.makeConstraints { (make) in
            make.width.height.equalTo(25)
            make.centerY.equalTo(self.labelName).offset(0)
            make.trailing.equalTo(self.imageViewMessage.snp.leading).offset(-15)
        }
        
        self.labelDate.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.width.greaterThanOrEqualTo(30)
            make.width.lessThanOrEqualTo(200)
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
    
    @objc func messageClick() {
        self.selectAction?.actionMessage(job: self.job!)
    }
    
    @objc func shareClick() {
        self.selectAction?.actionShare(job: self.job!)
    }
    
    @objc func detailClick() {
        self.selectAction?.actionDetail(job: self.job!)
    }
    
    @objc func callClick() {
        self.selectAction?.actionCall(job: self.job!)
    }
    
    @objc func favorieClick() {
        self.selectAction?.actionDelete(job: self.job!)
    }
    
    @objc func longClick() {
        self.selectAction?.actionLongClick(job: self.job!)
    }
    
    
    func setData(job: JobModel, selectAction: SelectActionFavorite) {
        self.job = job
        self.selectAction = selectAction
        self.labelName.text = job.postBy
        if job.phoneNumber == "Null"{
            self.actionCall.isHidden = true
        } else {
            self.actionCall.isHidden = false
        }
        
        if self.job?.image != nil {
            print("link image: \((self.job?.image)!)")
            self.labelContent.snp.removeConstraints()
            self.labelContent.snp.makeConstraints { (make) in
                make.leading.equalToSuperview().offset(15)
                make.trailing.equalToSuperview().offset(-15)
                make.top.equalTo(self.labelDate.snp.bottom).offset(0)
                make.height.equalTo(heightForLabel(text: (self.job?.message)!, font: DFont.fontLight(size: 16), width: UIScreen.main.bounds.size.width - 30))
            }
            
            self.imageJob.snp.makeConstraints { (make) in
                make.leading.equalToSuperview().offset(15)
                make.trailing.equalToSuperview().offset(-10)
                make.top.equalTo(self.labelContent.snp.bottom).offset(5)
                make.bottom.equalTo(self.actionView.snp.top).offset(-5)
            }
            
            self.imageJob.sd_setImage(with: URL(string: (self.job?.image)!), completed: nil)
        }
        
        self.labelCountFavorite.text = "( \(job.count_approach != nil ? job.count_approach! : 0) người tiếp cận )"
        self.labelDate.text = formatDate(date: job.postDate!)
        self.labelContent.text = job.message
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

