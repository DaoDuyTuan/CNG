//
//  AboutApp.swift
//  CNG
//
//  Created by Quang on 08/05/2018.
//  Copyright © 2018 Quang. All rights reserved.
//

import AdSupport
import Foundation
import UIKit

public struct AboutApp {
    
    public static var appName: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
    }
    
    public static var appVersion: String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    public static var appBuild: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
    
    public static var bundleIdentifier: String {
        return Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
    }
    
    public static var bundleName: String {
        return Bundle.main.infoDictionary!["CFBundleName"] as! String
    }
    
    public static var appStoreURL: URL {
        return URL(string: "your URL")!
    }
    
    public static var appVersionAndBuild: String {
        let version = appVersion, build = appBuild
        return version == build ? "v\(version)" : "v\(version)(\(build))"
    }
    
    public static var IDFV: String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    public static var deviceVersion: String {
        return UIDevice.current.systemVersion
    }
    
    public static var screenOrientation: UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }
    
    public static var screenStatusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    public static var screenHeightWithoutStatusBar: CGFloat {
        if UIInterfaceOrientationIsPortrait(screenOrientation) {
            return UIScreen.main.bounds.size.height - screenStatusBarHeight
        } else {
            return UIScreen.main.bounds.size.width - screenStatusBarHeight
        }
    }
}

public extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
    static var generation: GenerationType {
        let size = UIScreen.main.bounds.size
        
        if size.width == 375 && size.height == 667 {
            return GenerationType.iPhone8
        }
        else if size.width == 414 && size.height == 736 {
            return GenerationType.iPhone8Plus
        }
        else if size.width == 375 && size.height == 812 {
            return GenerationType.iPhoneX
        }
        else if size.width == 320 && size.height == 568 {
            return GenerationType.iPhoneSE
        }
        else if size.width == 768 && size.height == 1024 {
            return GenerationType.iPadMini
        }
        else if size.width == 768 && size.height == 1024 {
            return GenerationType.iPadAir
        }
        else if size.width == 834 && size.height == 1112 {
            return GenerationType.iPadPro10_5
        }
        else if size.width == 1024 && size.height == 1366 {
            return GenerationType.iPadPro12_9
        }
        
        return GenerationType.unknow
    }
    
    static var statusBar: StatusBar {
        let size = UIScreen.main.bounds.size
        
        if size.width == 375 && size.height == 667 {
            return StatusBar.unknow
        }
        else if size.width == 414 && size.height == 736 {
            return StatusBar.unknow
        }
        else if size.width == 375 && size.height == 812 {
            return StatusBar.iPhoneX
        }
        
        return StatusBar.unknow
    }
    
    static var tabbar: Tabbar {
        let size = UIScreen.main.bounds.size
        
        if size.width == 375 && size.height == 667 {
            return Tabbar.unknow
        }
        else if size.width == 414 && size.height == 736 {
            return Tabbar.unknow
        }
        else if size.width == 375 && size.height == 812 {
            return Tabbar.iPhoneX
        }
        
        return Tabbar.unknow
    }
}

public enum GenerationType: Int {
    case unknow
    case iPhone8
    case iPhone8Plus
    case iPhoneX
    case iPhoneSE
    case iPadMini
    case iPadAir
    case iPadPro10_5
    case iPadPro12_9
}

public enum StatusBar: Int {
    case unknow = 20
    case iPhoneX = 44
}

public enum Tabbar: Int {
    case unknow = 48
    case iPhoneX = 83
}

