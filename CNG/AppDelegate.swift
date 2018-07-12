//
//  AppDelegate.swift
//  CNG
//
//  C/Users/quang/Documents/OpenCup/CNG/CNG/CNG/Extensionreated by Quang on 03/05/2018.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?

    static var shared: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
    var topMost: UIViewController {
        get {
            let root = self.window?.rootViewController!
            if let top = root?.presentingViewController {
                return top
            }
            
            if let top = root?.presentedViewController {
                return top
            }
            
            return root!
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // setup facebook
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (isGranted, err) in
            if err != nil {
                //Something bad happend
            } else {
                UNUserNotificationCenter.current().delegate = self
                Messaging.messaging().delegate = self
                
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }

        FirebaseApp.configure()
        if (UserDefaults.standard.value(forKey: "FIRST_OPEN_APP") == nil){
            Util.copyFile(fileName: "data.sqlite")
            UserDefaults.standard.set(false, forKey: "FIRST_OPEN_APP")
        }
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        if(!iRate.sharedInstance().ratedAnyVersion){
            UserDefaults.standard.set(false, forKey: "ISRATE")
        }
        iRate.sharedInstance().daysUntilPrompt = 1
        iRate.sharedInstance().usesUntilPrompt = 1
        if UserModel.userCache != nil {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = TabbarVC()
            self.window?.makeKeyAndVisible()
        }
        
        UIApplication.shared.statusBarStyle = .lightContent
        return true
    }

    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        let newToken = InstanceID.instanceID().token()
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
  
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
   
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}

