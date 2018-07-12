//
//  TabbarVC.swift
//  CNG
//
//  Created by Quang on 04/05/2018.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

class TabbarVC: UITabBarController {
    // MARK: properties
    // MARK: properties view
    fileprivate let homeVC:RequestViewController = {
        let view = RequestViewController()
        view.tabBarItem.title = "Yêu cầu"
        view.tabBarItem.image = UIImage(named: "ic_developer_board_white")
        view.tabBarItem.selectedImage = UIImage(named: "ic_developer_board_white")
        return view;
    }()
    
    fileprivate let achievementsVC:ApproachedViewController = {
        let view = ApproachedViewController()
        view.tabBarItem.title = "Đã tiếp cận"
        view.tabBarItem.image = UIImage(named: "ic_select_all_white")
        view.tabBarItem.selectedImage = UIImage(named: "ic_select_all_white")
        return view;
    }()
    
    fileprivate let addVC: ListPostedViewController = {
        let view = ListPostedViewController(nibName: "ListPostedViewController", bundle: nil)
        view.tabBarItem.title = "Đăng bài"
        view.tabBarItem.image = UIImage(named: "add")
        view.tabBarItem.selectedImage = UIImage(named: "add")
        return view;
    }()
    
    fileprivate let settingVC:AccountViewController = {
        let view = AccountViewController()
        view.tabBarItem.title = "Tài khoản"
        view.tabBarItem.image = UIImage(named: "ic_account_circle_white")
        view.tabBarItem.selectedImage = UIImage(named: "ic_account_circle_white")
        return view;
    }()
    
    // MARK: dealloc
    deinit {
        BLogInfo("")
    }
    
    // MARK: - Life cycle Viewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        initSubviews()
        initConstraint()
//        self.addVC.backBlock = { () in
//            self.selectedViewController = self.viewControllers?[0]
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - private method
    private func initViews() {
        self.tabBar.tintColor = DColor.whiteColor
        self.tabBar.barTintColor = DColor.readColor
        
        // remove top line in tabbar
        self.tabBar.layer.borderWidth = 0.0
        self.tabBar.clipsToBounds = true
    }
    
    private func initSubviews() {
        let tab1 = UINavigationController(rootViewController: homeVC)
        let tab2 = UINavigationController(rootViewController: achievementsVC)
        let tab3 = UINavigationController(rootViewController: addVC)
        let tab4 = UINavigationController(rootViewController: settingVC)
        
        tab1.navigationBar.isTranslucent = false
        tab1.navigationBar.isHidden = true
        
        tab2.navigationBar.isTranslucent = false
        tab2.navigationBar.isHidden = true
        
        tab3.navigationBar.isTranslucent = false
        tab3.navigationBar.isHidden = true
        
        tab4.navigationBar.isTranslucent = false
        tab4.navigationBar.isHidden = true
        self.viewControllers = [tab1, tab2, tab3, tab4]
    }
    
    private func initConstraint() {
        
    }
    
    // MARK: - public method
    override var selectedViewController: UIViewController? {
        didSet {
            if let val = selectedViewController {
                let navi = val as! UINavigationController
                if (navi.topViewController?.isEqual(self.homeVC))! {
                    self.tabBar.tintColor = DColor.whiteColor
                    self.tabBar.isHidden = false
                }
                else if (navi.topViewController?.isEqual(self.achievementsVC))! {
                    self.tabBar.tintColor = DColor.whiteColor
                    self.tabBar.isHidden = false
                }
                else if (navi.topViewController?.isEqual(self.addVC))! {
                    self.tabBar.tintColor = DColor.whiteColor
                    self.tabBar.isHidden = true
                }
                else if (navi.topViewController?.isEqual(self.settingVC))! {
                    self.tabBar.tintColor = DColor.whiteColor
                    self.tabBar.isHidden = false
                }
            }
        }
    }
    
    // MARK: events
    
    
}
