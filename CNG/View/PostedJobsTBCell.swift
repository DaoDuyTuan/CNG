//
//  PostedJobsTBCell.swift
//  CNG
//
//  Created by Quang on 6/9/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

class PostedJobsTBCell: BaseTableCell {
    
    fileprivate let imageview: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = image.frame.height / 2
        return image
    }()

    fileprivate let lableContent: UILabel = {
        let view = UILabel()
        view.textColor = DColor.blackColor
        view.font = DFont.fontLight(size: 16)
        view.textAlignment = NSTextAlignment.left
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0
        return view
    }()
    
    fileprivate let labelTime: UILabel = {
        let label = UILabel()
        label.textColor = DColor.blackOpacity85Percent
        label.font = DFont.fontLight(size: 12)
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate let viewImage: UIButton = {
        let image = UIButton()
        image.setTitle("  Xem ảnh  ", for: .normal)
        image.backgroundColor = UIColor.myDarkTextColor
        image.setTitleColor(UIColor.white, for: .normal)
        image.layer.cornerRadius = 5.0
        return image
    }()
    
    fileprivate var checkBox: UILabel = {
        let checkbox = UILabel()
        checkbox.attributedText = Util.attributedString(color: UIColor.red, string: "Đăng lại")
        checkbox.font = DFont.fontLight(size: 15)
        return checkbox
    }()
    fileprivate var job: JobModel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(imageview)
        self.addSubview(lableContent)
        self.addSubview(labelTime)
        self.addSubview(viewImage)
        self.addSubview(checkBox)
        self.viewImage.addTarget(self, action: #selector(viewImageDetail), for: .touchUpInside)
        
        self.imageview.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview().offset(0)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        self.lableContent.snp.makeConstraints { (make) in
            make.leading.equalTo(self.imageview.snp.trailing).offset(10)
            make.top.equalToSuperview().offset(10)
            make.trailing.equalTo(self.checkBox.snp.leading).offset(-10)
            make.bottom.equalTo(self.labelTime.snp.top).offset(-5)
        }
        
        self.checkBox.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview().offset(10)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        self.labelTime.snp.makeConstraints { (make) in
            make.leading.equalTo(self.imageview.snp.trailing).offset(10)
            make.top.equalTo(self.lableContent.snp.bottom).offset(10)
            make.height.equalTo(20)
        }
        
        self.viewImage.snp.makeConstraints { (make) in
            make.leading.equalTo(self.imageview.snp.trailing).offset(10)
            make.top.equalTo(self.labelTime.snp.bottom).offset(10)
            make.height.equalTo(0.52 * (self.contentView.height))
        }
    }
    
    @objc func viewImageDetail() {
        if let images = self.job?.image {
            let imageList = images.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").split(separator: ",")
            let _ = imageList.map({ImageDetail.dataFromUser.append(url + String($0))})
            let viewNib = Bundle.main.loadNibNamed("ImageDetail", owner: self, options: nil)?[0] as! ImageDetail
            Utils.animateIn(view: viewNib)
            viewNib.frame = (UIApplication.shared.delegate?.window??.bounds)!
            UIApplication.shared.delegate?.window??.addSubview(viewNib)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initData(job: JobModel) {
        self.job = job
        if let id = user.id {
            self.imageview.layer.cornerRadius = self.imageview.frame.height / 2
            self.imageview.sd_setImage(with: URL(string: "https://graph.facebook.com//\(id)/picture?type=large"))
        }
        self.labelTime.text = "\(formatDate(date: job.postDate!))"
        self.lableContent.text = job.message
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
