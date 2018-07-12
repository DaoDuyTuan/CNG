//
//  StepView.swift
//  CNG
//
//  Created by Quang on 6/1/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

enum Step: Int{
    case dashboard = 0
    case group = 1
    case area = 2
}

class StepView: UIView {

    fileprivate let imageStep1: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 17
        image.backgroundColor = DColor.grayColor
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "dashboard")?.imageWithInsets(insets: UIEdgeInsetsMake(7, 7, 7, 7))
        return image
    }()
    
    fileprivate let imageStep2: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 17
        image.backgroundColor = DColor.grayColor
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "group")?.imageWithInsets(insets: UIEdgeInsetsMake(7, 7, 7, 7))
        return image
    }()
    
    fileprivate let imageStep3: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 17
        image.backgroundColor = DColor.grayColor
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "area")?.imageWithInsets(insets: UIEdgeInsetsMake(7, 7, 7, 7))
        return image
    }()
    
    fileprivate let viewLine: UIView = {
        let view = UIView()
        view.backgroundColor = DColor.grayColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(viewLine)
        self.addSubview(imageStep1)
        self.addSubview(imageStep2)
        self.addSubview(imageStep3)
        
        self.viewLine.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().offset(0)
            make.height.equalTo(2)
            make.centerY.equalToSuperview().offset(0)
        }
        
        self.imageStep1.snp.makeConstraints { (make) in
            make.width.height.equalTo(34)
            make.centerY.equalToSuperview().offset(0)
            make.leading.equalToSuperview().offset(0)
        }
        
        self.imageStep2.snp.makeConstraints { (make) in
            make.width.height.equalTo(34)
            make.centerY.equalToSuperview().offset(0)
            make.centerX.equalToSuperview().offset(0)
        }
        
        self.imageStep3.snp.makeConstraints { (make) in
            make.width.height.equalTo(34)
            make.centerY.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(0)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    func setStep(step: Step){
        self.imageStep1.backgroundColor = DColor.grayColor
        self.imageStep2.backgroundColor = DColor.grayColor
        self.imageStep3.backgroundColor = DColor.grayColor
        switch step {
        case .dashboard:
            self.imageStep1.backgroundColor = DColor.blueColor
        case .group:
            self.imageStep2.backgroundColor = DColor.blueColor
        case .area:
            self.imageStep3.backgroundColor = DColor.blueColor
        }
    }
}
