//
//  CustomDialogJobDetail.swift
//  CNG
//
//  Created by Quang on 5/15/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

class CustomDialogJobDetail: UIView {

    fileprivate let viewContent: UIView = {
        let view = UIView()
        view.backgroundColor = DColor.blackOpacity15Percent
        return view
    }()

    fileprivate let viewCenter: UIView = {
        let view = UIView()
        view.backgroundColor = DColor.whiteColor
        return view
    }()

    fileprivate let labelTitle: UILabel = {
        let label = UILabel()
        label.textColor = DColor.blackColor
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = DFont.fontItalic(size: 16)
        return label
    }()

    fileprivate let labelParticipation: UILabel = {
        let label = UILabel()
        label.textColor = DColor.whiteColor
        label.text = "Tham gia"
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        label.backgroundColor = UIColor.blue
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.lineBreakMode = .byWordWrapping
        label.font = DFont.fontBold(size: 16)
        return label
    }()
    
    fileprivate let labelDetail: UILabel = {
        let label = UILabel()
        label.textColor = DColor.whiteColor
        label.text = "Chi tiết việc"
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        label.backgroundColor = DColor.readColor
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.lineBreakMode = .byWordWrapping
        label.font = DFont.fontBold(size: 16)
        return label
    }()
    
    fileprivate let labelNote: UILabel = {
        let label = UILabel()
        label.textColor = DColor.readColor
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        label.text = "*Hãy tham gia group để có thể xem chi tiết công việc"
        label.lineBreakMode = .byWordWrapping
        label.font = DFont.fontItalic(size: 14)
        return label
    }()
    
    var job: JobModel?{
        willSet{
            self.labelTitle.text = newValue?.byGroup
        }
    }
    
    var participationSelect: (() -> ())?
    
    var detailSelect: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(viewContent)
        self.viewContent.addSubview(viewCenter)
        viewCenter.addSubview(labelTitle)
        viewCenter.addSubview(labelParticipation)
        viewCenter.addSubview(labelDetail)
        viewCenter.addSubview(labelNote)
        
        self.viewContent.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview().offset(0)
        }
        
        self.viewCenter.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(1.0/3.0)
            make.width.equalToSuperview().multipliedBy(9.0/10.0)
            make.center.equalToSuperview().offset(0)
        }
        
        self.labelTitle.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(1.0/3.0)
            make.top.equalToSuperview().offset(0)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
        }
    
        self.labelNote.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(0)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalToSuperview().multipliedBy(1.0/3.0)
        }
        
        self.labelParticipation.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(25)
            make.height.equalToSuperview().multipliedBy(2.0/9.0)
            make.width.equalToSuperview().multipliedBy(1.0/3.0)
            make.centerY.equalToSuperview().offset(0)
        }
        
        self.labelDetail.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalToSuperview().multipliedBy(2.0/9.0)
            make.width.equalToSuperview().multipliedBy(1.0/3.0)
            make.centerY.equalToSuperview().offset(0)
        }
        
        self.viewContent.isUserInteractionEnabled = true
        self.viewCenter.isUserInteractionEnabled = true
        self.labelParticipation.isUserInteractionEnabled = true
        self.labelDetail.isUserInteractionEnabled = true
        
        self.viewContent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTouchCancel)))
        self.viewCenter.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTouchNil)))
        self.labelParticipation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTouchParticipation)))
        self.labelDetail.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTouchDetail)))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTouchCancel()  {
        self.removeFromSuperview()
    }
    
    @objc func didTouchNil()  {
        
    }
    
    @objc func didTouchParticipation()  {
        if let block = participationSelect {
            block()
        }
        didTouchCancel()
    }
    
    @objc func didTouchDetail()  {
        if let block = detailSelect {
            block()
        }
        didTouchCancel()
    }
}
