//
//  EmailService.swift
//  CNG
//
//  Created by Quang on 08/05/2018.
//  Copyright © 2018 Quang. All rights reserved.
//

import Foundation
import MessageUI
import PopupDialog
class EmailService: NSObject {
    private let email_feedback = "quang.phungvan1996@gmail.com"
    
    //MARK: Shared Instance
    static let sharedInstance : EmailService = {
        let instance = EmailService()
        return instance
    }()
    
    override init() {
        
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.navigationBar.tintColor =  UIColor(102,187,106)
            composeVC.mailComposeDelegate = self
            
            let title = "[\(AboutApp.appName)] Giúp đỡ"
            var messeageBody = String()
            messeageBody.append("\n\n\n------------------------------------\n")
            messeageBody.append("Phiên bản hệ điều hành IOS : \(AboutApp.deviceVersion)\n")
            messeageBody.append("Tên thiết bị: \(UIDevice.current.modelName)\n")
            messeageBody.append("Phiên bản ứng dụng: \(AboutApp.appVersion)\n")
            
            composeVC.setToRecipients([email_feedback])
            composeVC.setSubject(title)
            composeVC.setMessageBody(messeageBody, isHTML: false)
            
            AppDelegate.shared.topMost.present(composeVC, animated: true, completion: nil)
        }
        else {
            let popup = PopupDialog(title: "Thông báo",
                                    message: "Bạn chưa cài đặt email vui lòng kiểm tra lại",
                                    buttonAlignment: .horizontal,
                                    transitionStyle: .zoomIn,
                                    gestureDismissal: true) {
                                        print("Completed")
            }
            // Create buttons
            let buttonOne = DefaultButton(title: "Đồng ý") {
                print("You canceled the dialog.")
            }
            popup.addButtons([buttonOne])
            AppDelegate.shared.topMost.present(popup, animated: true, completion: nil)
        }
    }
}

// MARK: MFMailComposeViewControllerDelegate
extension EmailService: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
}

