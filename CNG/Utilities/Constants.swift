//
//  Constants.swift
//  CNG
//
//  Created by Quang on 03/05/2018.
//  Copyright © 2018 Quang. All rights reserved.
//

import Foundation
import UIKit
import KeychainAccess
import SDWebImage


public let idapp = "1330297156"
public let linkapp = "itms-apps://itunes.apple.com/app/id1330297156"
public let noteStr = "";

public let fanpage = "https://www.facebook.com/cngvietnam/"
public let group = "https://www.facebook.com/groups/226784898078344/"

class Constants: NSObject {

}
public func widthForLabel(text:String, font:UIFont, height:CGFloat) -> CGFloat {
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: height))
    label.font = font
    label.text = text
    label.sizeToFit()
    return label.frame.width
}

public func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    label.sizeToFit()
    return label.frame.height
}

public func heightForImageView(nameImage:String, width:CGFloat) -> CGFloat{
    let imageView:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    imageView.image = UIImage(named: nameImage)
    imageView.contentMode = .scaleToFill
    imageView.sizeToFit()
    return imageView.frame.height
}

public func heightForImageView(url:URL, width:CGFloat) -> CGFloat{
    let imageView:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    imageView.sd_setImage(with: url, completed: nil)
    imageView.contentMode = .scaleToFill
    imageView.sizeToFit()
    return imageView.frame.height
}

// Define all function common in app
class DCommon: NSObject {
    static let SCORE_PRACTICE_NEW_WORD:Int = 10
    static let SCORE_PRACTICE:Int = 60 // 150 point/answer correct
    static let SCORE_SPEED_TEST:Int = 30
    
    static var deviceToken : String? {
        get {
            if let value = UserDefaults.standard.value(forKey: "DEVICE_TOKEN") {
                return value as? String
            } else {
                return ""
            }
        }
        set(newValue) {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: "DEVICE_TOKEN")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    static var deviceID : String? {
        get {
            let keychain = Keychain(service: "com.opencup.CNG")
            if let value = keychain["DEVICE_ID"] {
                return value
            } else {
                keychain["DEVICE_ID"] = UUID().uuidString
                return keychain["DEVICE_ID"]
            }
        }
        set(newValue) {
            if let value = newValue {
                let keychain = Keychain(service: "com.opencup.CNG")
                keychain["DEVICE_ID"] = value
            }
        }
    }
    
    static var userCache : [String:Any]?  {
        get {
            if let value = UserDefaults.standard.value(forKey: "KEY_USER_CACHE") {
                return value as? [String:Any]
            }
            return nil
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "KEY_USER_CACHE")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var openAppTheFirst : Bool {
        get {
            if let _ = UserDefaults.standard.value(forKey: "OPEN_APP_THE_FIRST") {
                return false
            } else {
                return true
            }
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "OPEN_APP_THE_FIRST")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var settingNotifyTheFirst : Bool {
        get {
            if let _ = UserDefaults.standard.value(forKey: "SETTING_NOTIFY_THE_FIRST") {
                return false
            } else {
                return true
            }
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "SETTING_NOTIFY_THE_FIRST")
            UserDefaults.standard.synchronize()
        }
    }
    
//    static let permissionFB = ["public_profile","email","user_friends"]
    static let permissionFB = ["public_profile", "email"]
}

class DColor: NSObject {

    public static let whiteColor = UIColor.white
    public static let blackColor = UIColor.black
    public static let blackOpacity15Percent = UIColor.colorFromHexString(hex: "101010").withAlphaComponent(0.15)
    public static let blackOpacity85Percent = UIColor.colorFromHexString(hex: "101010").withAlphaComponent(0.85)
    public static let blueColor = UIColor.blue
    public static let readColor = UIColor(hex: 0xca1e3d)
    public static let grayColor = UIColor.colorFromHexString(hex: "e0e0e0")
    
}

class DFont: NSObject {
    static func fontRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Medium", size: size)!
    }
    
    static func fontBold(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Bold", size: size)!
    }
    
    static func fontLight(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Light", size: size)!
    }
    
    static func fontItalic(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Italic", size: size)!
    }
}
