//
//  ApproachedViewController.swift
//  CNG
//
//  Created by Quang on 04/05/2018.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

class ApproachedViewController: UIViewController {

    fileprivate var viewNavigationBar: UIView = {
        let view = UIView()
        view.backgroundColor = DColor.grayColor
        return view
    }()
    
    fileprivate var viewTitle: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.layer.borderWidth = 0.5
        view.layer.borderColor = DColor.grayColor.cgColor
        view.backgroundColor = DColor.whiteColor
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate var labelTitle: UILabel = {
        let view = UILabel()
        view.textColor = DColor.blackColor
        view.textAlignment = NSTextAlignment.center
        view.font = DFont.fontBold(size: 13)
        view.text = "DANH SÁCH CÔNG VIỆC BẠN QUAN TÂM"
        return view
    }()
    
    fileprivate var tableView: UITableView =  {
        let view = UITableView()
        view.separatorColor = DColor.whiteColor
        return view
    }()
    
    fileprivate var listJob: [JobModel]?{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FavoriteJobItemTableViewCell.registerCellByClass(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "JobCellTableViewCell", bundle: nil), forCellReuseIdentifier: "JobPostImage")
        self.tableView.register(UINib(nibName: "JobNotImageCellTableViewCell", bundle: nil), forCellReuseIdentifier: "JobPostNotImage")
        initValue()
        addSubView()
        initContrains()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initValue() {
        APIManage.shared.getListFavorite(idUser: UserModel.init(data: UserModel.userCache!).id!) { (success, listJob) in
            if success {
                self.listJob = listJob
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initValue()
    }
    func addSubView() {
        self.view.addSubview(viewNavigationBar)
        self.viewNavigationBar.addSubview(viewTitle)
        self.viewTitle.addSubview(labelTitle)
        self.view.addSubview(tableView)
    }
    func initContrains() {
        
        self.viewNavigationBar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview().offset(0)
            make.height.equalTo(UIDevice.statusBar.rawValue + 44)
        }
        
        self.viewTitle.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(UIDevice.statusBar.rawValue + 5)
            make.bottom.equalToSuperview().offset(-5)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
        }
        
        self.labelTitle.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().offset(0)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().offset(0)
            make.top.equalTo(self.viewNavigationBar.snp.bottom).offset(0)
            make.bottom.equalToSuperview().offset(UIDevice.tabbar.rawValue)
        }
    }
}
extension ApproachedViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listJob == nil ? 0 : (self.listJob?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let job = self.listJob?[indexPath.row] ?? JobModel(data: [:])
        if let image = job.image {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JobPostNotImage", for: indexPath) as! JobNotImageCellTableViewCell
            cell.job = job
            cell.lblNameUser.text = job.postBy
            cell.lblFollow.text = "(\(job.count_approach != nil ? job.count_approach! : 0) người tiếp cận )"
            cell.lblContentPost.text = job.message
            cell.btnSaveOrDelete.tag = 1
            cell.selectionDelegate = self
            cell.lblSaveOrDelete.text = "Xoá"
            cell.iconSaveOrDelete.image = UIImage(named: "iTunesArtwork-4")
            
            if job.isLoadFromFirbase {
                cell.lblDatePost.text = "\(job.postDate!)  \((job.address)!) \((job.category_name)!) \((job.job_name)!)"
            } else {
                cell.lblDatePost.text = "\(RequestViewController.formatDate(date: job.postDate!))  \((job.address)!) \((job.category_name)!) \((job.job_name)!)"
            }
            
            let images = image.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").split(separator: ",")
            
            if images.count > 3 {
                cell.showImageCount.isHidden = false
                cell.lblShowCountImage.text = "+\(images.count - 3)"
            } else {
                cell.showImageCount.isHidden = true
                switch images.count {
                case 1:
                    cell.setImageOfUser[0].isHidden = false
                    cell.setImageOfUser[1].isHidden = true
                    cell.setImageOfUser[2].isHidden = true
                case 2:
                    cell.setImageOfUser[0].isHidden = false
                    cell.setImageOfUser[1].isHidden = false
                    cell.setImageOfUser[2].isHidden = true
                default:
                    print("default")
                }
            }
            
            for (index, src) in images.enumerated() {
                if index < 3 {
                    cell.setImageOfUser[index].isHidden = false
                    cell.setImageOfUser[index].sd_setImage(with: URL(string: url + src), completed: nil)
                }
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JobPostImage", for: indexPath) as! JobCellTableViewCell
            cell.job = job
            cell.selectionDelegate = self
            cell.lblNameUser.text = job.postBy
            cell.lblFollow.text = "(\(job.count_approach != nil ? job.count_approach! : 0) người tiếp cận )"
            cell.lblContentPost.text = job.message
            cell.btnSaveOrDelete.tag = 1
            cell.lblSaveOrDelete.text = "Xoá"
            cell.iconSaveOrDelete.image = UIImage(named: "iTunesArtwork-4")
            if job.isLoadFromFirbase {
                cell.lblDatePost.text = "\(job.postDate!) \((job.category_name)!) \((job.job_name)!)"
            } else {
                cell.lblDatePost.text = "\(RequestViewController.formatDate(date: job.postDate!)) \((job.category_name)!) \((job.job_name)!)"
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.listJob![indexPath.row].image == nil{
            return self.listJob == nil ? 0 : (120 + heightForLabel(text: self.listJob![indexPath.row].message!, font: DFont.fontLight(size: 16), width: UIScreen.main.bounds.size.width - 30))
        } else {
            return self.listJob == nil ? 0 : (220 + heightForLabel(text: self.listJob![indexPath.row].message!, font: DFont.fontLight(size: 16), width: UIScreen.main.bounds.size.width - 30) + heightForImageView(url: URL(string: self.listJob![indexPath.row].image!)!, width: UIScreen.main.bounds.size.width - 30))
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
}

extension ApproachedViewController: SelectAction {
    
    func actionFavorite(job: JobModel, index: Int) {
        
    }
    
    func actionDetail(job: JobModel,index: Int) {
        
        if job.byGroup != nil {
            let dialog = CustomDialogJobDetail()
            dialog.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            dialog.job = job
            dialog.participationSelect = { () in
                if let checkURL = NSURL(string: job.linkGroup ?? "") {
                    if UIApplication.shared.openURL(checkURL as URL) {
                        print("url successfully opened")
                    }
                } else {
                }
            }
            dialog.detailSelect = { () in
                if let checkURL = NSURL(string: job.postLink ?? "") {
                    if UIApplication.shared.openURL(checkURL as URL) {
                        print("url successfully opened")
                    }
                } else {
                }
            }
            self.view.addSubview(dialog)
        } else {
            if let checkURL = NSURL(string: job.postLink ?? "") {
                if UIApplication.shared.openURL(checkURL as URL) {
                    print("url successfully opened")
                }
            } else {
            }
        }
        self.updateMainJobList(job: job, index: index)
    }
    
    func actionCall(job: JobModel, index: Int) {
        guard let phone = job.phoneNumber, phone != "Null" else {
            let _ = MyAlert().showAlert("Không tìm thấy số!")
            return
        }
        self.updateMainJobList(job: job, index: index)
        guard let number = URL(string: "tel://" + phone) else { return }
        UIApplication.shared.openURL(number)
    }
    
    func actionDelete(job: JobModel) {
        APIManage.shared.deleteListFavorite(idJob: "\((job.oder_id!))", idUser: UserModel(data: UserModel.userCache!).id!) { (success) in
            if success {
                if let index = self.listJob?.index(of: job) {
                    self.listJob?.remove(at: index)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func actionMessage(job: JobModel, index: Int) {
        self.updateMainJobList(job: job, index: index)
        if let checkURL = NSURL(string: "https://www.facebook.com/messages/t/\((job.postWall?.replacingOccurrences(of: "https://facebook.com/", with: ""))!)") {
            if UIApplication.shared.openURL(checkURL as URL) {
                print("url successfully opened")
            }
        } else {
            
        }
    }
    
    func actionLongClick(job: JobModel, index: Int) {
        let text = "\(job.message) Chi tiêt công việc tại: \(job.postWall) Bạn có thể tiếp cận vô số công việc khi sử dụng ứng dụng của chúng tôi: \(linkapp)"
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func actionShare(job: JobModel, index: Int) {
        self.updateMainJobList(job: job, index: index)
        let text = "\(job.message) Chi tiêt công việc tại: \(job.postWall) Bạn có thể tiếp cận vô số công việc khi sử dụng ứng dụng của chúng tôi: \(linkapp)"
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    func updateMainJobList(job: JobModel, index: Int) {
        if job.count_approach != self.listJob?[index].count_approach {
            self.listJob?[index] = job
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
}

extension ApproachedViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RequestViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
