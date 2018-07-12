//
//  UtilManage.swift
//  CNG
//
//  Created by Quang on 5/10/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit
import SystemConfiguration

public enum BAlertType: Int {
    case ok = 0
    case yesNo
    case cancel
}

public enum BButtonResult: Int {
    case ok = 0
    case yes
    case no
    case cancel
}

private enum ActionTitle: String {
    case ok = "OK"
    case yes = "Yes"
    case no = "No"
    case cancel = "Cancel"
}


typealias alertTapHandler = (_ alertView: UIAlertController, _ button: BButtonResult) -> ()
typealias actionSheetTapHandler = (_ titleSelected: String, _ button: BButtonResult?) -> ()

class UtilManage: NSObject {
    
    class func showAlert(message: String, type: BAlertType, complete: alertTapHandler?) {
        showAlert(title: "", message: message, type: type, complete: complete)
    }
    class func showAlert(title: String, message: String, type: BAlertType, complete: alertTapHandler?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        switch type {
        case .ok:
            let ok = UIAlertAction(title: ActionTitle.ok.rawValue, style: .destructive, handler: { (alertAction) in
                if let complete = complete {
                    complete(alert, .ok)
                }
            })
            alert.addAction(ok)
            
        case .yesNo:
            let yes = UIAlertAction(title: ActionTitle.yes.rawValue, style: .destructive, handler: { (alertAction) in
                if let complete = complete {
                    complete(alert, .yes)
                }
            })
            
            let no = UIAlertAction(title: ActionTitle.no.rawValue, style: .default, handler: { (alertAction) in
                if let complete = complete {
                    complete(alert, .no)
                }
            })
            
            alert.addAction(yes)
            alert.addAction(no)
            
        case .cancel:
            let cancel = UIAlertAction(title: ActionTitle.cancel.rawValue, style: .destructive, handler: { (alertAction) in
                if let complete = complete {
                    complete(alert, .cancel)
                }
            })
            alert.addAction(cancel)
        }
        
        AppDelegate.shared.topMost.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: alert
    class func alert(message: String, type: BAlertType, complete: alertTapHandler?) {
        alert(title: "", message: message, type: type, complete: complete)
    }
    
    class func alert(title: String, message: String, type: BAlertType, complete: alertTapHandler?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        switch type {
        case .ok:
            let ok = UIAlertAction(title: ActionTitle.ok.rawValue, style: .destructive, handler: { (alertAction) in
                if let complete = complete {
                    complete(alert, .ok)
                }
            })
            alert.addAction(ok)
            
        case .yesNo:
            let yes = UIAlertAction(title: ActionTitle.yes.rawValue, style: .destructive, handler: { (alertAction) in
                if let complete = complete {
                    complete(alert, .yes)
                }
            })
            
            let no = UIAlertAction(title: ActionTitle.no.rawValue, style: .default, handler: { (alertAction) in
                if let complete = complete {
                    complete(alert, .no)
                }
            })
            
            alert.addAction(yes)
            alert.addAction(no)
            
        case .cancel:
            let cancel = UIAlertAction(title: ActionTitle.cancel.rawValue, style: .destructive, handler: { (alertAction) in
                if let complete = complete {
                    complete(alert, .cancel)
                }
            })
            alert.addAction(cancel)
        }
        
        AppDelegate.shared.topMost.present(alert, animated: true, completion: nil)
    }
    
    class func share(text: String, sourceView:UIView?, viewcontroller:UIViewController) {
        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        if activity.popoverPresentationController != nil {
            activity.popoverPresentationController?.sourceView = sourceView
        }
        
        viewcontroller.present(activity, animated: true, completion: nil)
    }
    
    class func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let result = (isReachable && !needsConnection)
        
        if !result {
            UIAlertController.customInit().showDefault(title: "Notification", message: "Can't connect to internet")
        }
        
        return result
    }
    
    class func getPath(fileName: String) -> String {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        print(fileURL)
        return fileURL.path
    }
    
    class func copyFile(fileName: NSString) {
        let dbPath: String = getPath(fileName: fileName as String)
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dbPath) {
            let documentsURL = Bundle.main.resourceURL
            let fromPath = documentsURL!.appendingPathComponent(fileName as String)
            do {
                try fileManager.copyItem(atPath: fromPath.path, toPath: dbPath)
            } catch {
            }
        }
    }
    
}


