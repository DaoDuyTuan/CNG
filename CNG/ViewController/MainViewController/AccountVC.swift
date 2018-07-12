//
//  AccountViewController.swift
//  CNG
//
//  Created by Quang on 04/05/2018.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

 enum TypeActionOfAccount {
    case updateInfor
    case puchare
    case rateApp
    case fanpage
    case group
    case share
    case feedback
    case signOut
    case setting
    
    func getTitle() -> String {
        switch self {
        case .updateInfor:
            return "Cập nhập thông tin"
        case .puchare:
            return "Mua gói dịch vụ"
        case .rateApp:
            return "Đánh giá ứng dụng"
        case .fanpage:
            return "Fanpage CNG Việt Nam"
        case .group:
            return "Group cộng đồng CNG Việt Nam"
        case .share:
            return "Chia sẻ bạn bè"
        case .feedback:
            return "Góp ý sản phẩm"
        case .signOut:
            return "Đăng xuất tài khoản"
        case .setting:
            return "Cài đặt thông báo"

        }
    }
    
    func getImage() -> String {
        switch self {
        case .updateInfor:
            return "ic_description_36pt"
        case .puchare:
            return "ic_card_travel_36pt"
        case .rateApp:
            return "ic_star_36pt"
        case .fanpage:
            return "ic_description_36pt"
        case .group:
            return "ic_group_work_36pt"
        case .share:
            return "ic_share_36pt"
        case .feedback:
            return "ic_description_36pt"
        case .signOut:
            return "ic_description_36pt"
        case .setting:
            return "ic_description_36pt"
        }
    }
    
}

class AccountViewController: UIViewController {

    fileprivate var viewAvatar: UIView = {
        let view = UIView()
        
        return view
    }()
    
    fileprivate var imageAvatar: UIImageView  = {
        let image = UIImageView()
        image.backgroundColor = DColor.whiteColor
        image.sd_setImage(with: URL(string: "https://graph.facebook.com//\((UserModel(data: UserModel.userCache!).id)!)/picture?type=large"), completed: { (image, erroe, type, url) in
        })
        return image
    }()
    
    fileprivate var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = DColor.grayColor
        view.separatorColor = DColor.grayColor
        return view
    }()
    
    fileprivate let listTypeActionOfAccount: [TypeActionOfAccount] = [.updateInfor, .puchare, .rateApp, .fanpage, .group, .share, .feedback, .signOut, .setting]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DColor.readColor
        AccountActionTableViewCell.registerCellByClass(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(viewAvatar)
        self.viewAvatar.addSubview(imageAvatar)
        self.view.addSubview(tableView)
        
        self.viewAvatar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview().offset(0)
            make.height.equalToSuperview().multipliedBy(1.0/3.0)
        }
        
        self.imageAvatar.snp.makeConstraints { (make) in
            make.width.height.equalTo(90)
            make.center.equalToSuperview().offset(0)
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(-44)
            make.top.equalTo(self.viewAvatar.snp.bottom).offset(0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension AccountViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AccountActionTableViewCell.loadCell(tableView) as! AccountActionTableViewCell
        cell.typeAction = self.listTypeActionOfAccount[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.listTypeActionOfAccount[indexPath.row] {
        case .updateInfor:
            let vc = InformationVCViewController()
            vc.userModel = UserModel(data: UserModel.userCache!)
            vc.dismisVC = true
            self.present(vc, animated: true, completion: nil)
        case .puchare:
            
            break
        case .rateApp:
            iRate.sharedInstance().openRatingsPageInAppStore();
            break
        case.fanpage:
            if let checkURL = NSURL(string: fanpage) {
                if UIApplication.shared.openURL(checkURL as URL) {
                    print("url successfully opened")
                }
            } else {
            }
        case .group:
            if let checkURL = NSURL(string: group) {
                if UIApplication.shared.openURL(checkURL as URL) {
                    print("url successfully opened")
                }
            } else {
            }
        case .share:
            let url = URL(string: linkapp)!
            let textToShare = [url,noteStr] as [Any]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
            self.present(activityViewController, animated: true, completion: nil)
            break
        case .feedback:
            EmailService.sharedInstance.sendEmail()
            break
        case .signOut:
            UIAlertController.customInit().showDefault2(title: "Thông báo", message: "Bạn có chắc chắn muốn đăng xuất không? (Bạn sẽ phải đăng nhập lại)") { (success) in
                if success {
                    UserModel.userCache = nil
                    self.present(ViewController(), animated: true, completion: nil)
                }
            }
        case .setting:
            self.openSettingOnPhone()
        }
    }
    
    func openSettingOnPhone() {
        let alertController = UIAlertController (title: "Thông báo", message: "Bạn có muốn đến phần Setting không?", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
