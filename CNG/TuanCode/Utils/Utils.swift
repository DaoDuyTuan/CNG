//
//  Utils.swift
//  CNG
//
//  Created by Duy Tuan on 6/28/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

class Utils: NSObject {
    static func customItemBarButton(barButton: UITabBarItem, width: CGFloat, height: CGFloat, image: String) {
        let image = UIImage(named: image)
        let view = barButton.value(forKey: "view") as! UIView
        
        let button = UIButton.init(type: .custom)
        button.frame = view.frame
        button.frame.size = CGSize(width: width, height: height)
        button.setBackgroundImage(image, for: .normal)
    }
    
    static func warning(title: String, message: String, addActionOk: Bool, addActionCancel: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if addActionOk {
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {alert in
                if let topController = UIApplication.shared.keyWindow?.rootViewController {
                    topController.dismiss(animated: true, completion: nil)
                }
            }))
        }
        if addActionCancel {
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        }
        if let topController = UIApplication.shared.keyWindow?.rootViewController {
            topController.present(alert, animated: true, completion: nil)
        }
    }
    static func animateIn(view: UIView) {
        view.alpha = 1
        view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        UIView.animate(withDuration: 0.2, animations: {
            view.transform = .identity
        })
    }

    static func animateOut(view: UIView) {
        UIView.animate(withDuration: 0.2, animations: {
            view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            view.alpha = 0
        }) { (success: Bool) in
            view.removeFromSuperview()
        }
    }
}
extension UITextView {
    
    func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: self, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.inputAccessoryView = keyboardToolbar
    }
}
