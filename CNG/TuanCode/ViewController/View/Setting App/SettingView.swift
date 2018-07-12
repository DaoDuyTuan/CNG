//
//  Setting.swift
//  CNG
//
//  Created by Duy Tuan on 7/9/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit
import UserNotifications

class SettingView: UIView {
    
    @IBOutlet weak var myBG: UIView!
    @IBOutlet var views: [UIView]!
    
    var openSetting: (()->())?
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var parentView: UIView!
    override func awakeFromNib() {
        self.parentView.layer.cornerRadius = 5.0
        self.btnConfirm.layer.cornerRadius = 5.0
        
        for view in self.views {
            self.setUI(view: view)
        }
    }
    
    @IBAction func settingRung(_ sender: Any) {
    }
    
    @IBAction func settingSound(_ sender: Any) {
        let content = UNMutableNotificationContent()
        content.badge = 1
        content.categoryIdentifier = "aps"
    }
    
    @IBAction func confirmSetting(_ sender: Any) {
//        self.removeFromSuperview()
        if self.openSetting != nil {
            self.openSetting?()
        }
    }
    
    func setUI(view: UIView) {
        view.layer.cornerRadius = 5.0
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(displayP3Red: 235/255, green: 235/255, blue: 235/255, alpha: 1).cgColor
        view.layer.shadowOffset = CGSize(width: 0.5, height: 4.0)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 2.0
        view.layer.masksToBounds = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchs: UITouch? = touches.first
        if touchs?.view == self.myBG {
            Utils.animateOut(view: self)
        }
    }
}
