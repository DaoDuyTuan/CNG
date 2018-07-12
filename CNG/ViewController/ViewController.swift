//
//  ViewController.swift
//  CNG
//
//  Created by Quang on 03/05/2018.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import MBProgressHUD

class ViewController: UIViewController {

    @IBAction func loginFacebook(_ sender: Any) {
//        static let permissionFB = ["public_profile", "email"]
        FBSDKLoginManager().logIn(withReadPermissions: DCommon.permissionFB, from: self) { (result, error) in
            if error != nil{
                print(error!)
                return
            }

            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email, picture"]).start { (connection, result, error) in
                if error != nil {
                    UIAlertController.customInit().showDefault(title: "Thông báo", message: "Đăng nhập xảy ra lỗi")
                    return
                }

                if let data = result as? [String: Any] {
                    let id = data["id"] as? String
                    let name = data["name"] as? String
                    let email = data["email"] as? String
                    let vc = InformationVCViewController()
                    vc.name = name ?? nil
                    vc.email = email ?? nil
                    vc.id = id ?? nil
                    vc.dismisVC = false
                    self.present(vc, animated: true, completion: nil)
                }
                else {
                    UIAlertController.customInit().showDefault(title: "Thông báo", message: "Đăng nhập xảy ra lỗi")
                }
            }
        }

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

