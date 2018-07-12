//
//  ListPostedViewController.swift
//  CNG
//
//  Created by Duy Tuan on 7/11/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit
import SKActivityIndicatorView
import SDWebImage
import Alamofire

class ListPostedViewController: UIViewController {

    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageListUserCollectionView: UICollectionView!
    @IBOutlet weak var listPostedTableView: UITableView!
    @IBOutlet weak var btnCreatPost: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    
    var listImage = [String]()
    var listImg = [UIImage]()
    var listPost = [JobModel]()
    var listImgView = [[UIImage]]()
    var jobWillSelecte: JobModel?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }

    override func viewDidLayoutSubviews() {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        
        self.present(TabbarVC(), animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.listPostedTableView.estimatedRowHeight = 100
        self.listPostedTableView.rowHeight = UITableViewAutomaticDimension
        
        SKActivityIndicator.show()
        APIManage.shared.getJobUser(idUser: UserModel(data: UserModel.userCache!).id!) { (success, listJob) in
            if success {
                self.listPost = listJob
                self.listPostedTableView.reloadData()
            }
            SKActivityIndicator.dismiss()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let indexpath = self.indexPath {
            if let cell = self.listPostedTableView.cellForRow(at: indexpath) as? ListPostedTableViewCell {
                cell.lblCheckbox.text = ""
                self.listPostedTableView.reloadRows(at: [indexpath], with: .automatic)
                self.btnEdit.isHidden = true
                self.imageListUserCollectionView.isHidden = true
                self.bottomHeightConstraint.constant = 0
            }
        }
    }
    @IBAction func creatPost(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "postScreen")
        postJob = PostModel()
        postJob.img = ([], [])
        postJob.message = ""
        self.present(vc, animated: true, completion: nil)
    }
    
    func setUI() {
        self.btnEdit.isHidden = true
        self.btnEdit.layer.cornerRadius = 5.0
        self.btnEdit.layer.borderWidth = 1.0
        
        self.btnCreatPost.layer.borderWidth = 1.0
        self.btnCreatPost.layer.cornerRadius = 3.0
        self.btnEdit.layer.borderColor = UIColor.white.cgColor
        self.btnCreatPost.layer.borderColor = UIColor.black.cgColor
        
        self.listPostedTableView.register(UINib(nibName: "ListPostedTableViewCell", bundle: nil), forCellReuseIdentifier: "postCell")
        self.imageListUserCollectionView.register(UINib(nibName: "ImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionCell")
    }
    
    @IBAction func editPost(_ sender: Any) {
        if let job = self.jobWillSelecte {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "postScreen")
            postJob = PostModel()
            postJob.img = ([], [])
            postJob.message = job.message
            self.present(vc, animated: true, completion: nil)
        } else {
            let _ = MyAlert().showAlert("Bạn chưa chọn công việc!")
        }
    }
    
    func getData(job: JobModel) {
        
        let images = job.image?.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").split(separator: ",")
        for src in images! {
            DispatchQueue.global().async {
                Alamofire.download(URL(string: url + String(src))!).responseData { response in
                    if let data = response.result.value {
                        let image = UIImage(data: data)
                        self.listImg.append(image!)
                    }
                    DispatchSemaphore(value: 0).signal()
                }
            }
            let _ = DispatchSemaphore(value: 0).wait(timeout: .now() + 0.3)
        }
        self.imageListUserCollectionView.reloadData()
    }

}

extension ListPostedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! ListPostedTableViewCell
        let job = self.listPost[indexPath.row]
        cell.lblCheckbox.tag = indexPath.row
        cell.delegateEditPost = self
        cell.lblContent.text = job.message
        cell.lblTime.text = self.formatDate(date: job.postDate ?? "")
        cell.userImageView.sd_setImage(with: URL(string: "https://graph.facebook.com//\(user.id!)/picture?type=large"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.btnEdit.isHidden {
            self.btnEdit.isHidden = false
            UIView.animate(withDuration: 1.0, animations: {
                self.imageListUserCollectionView.isHidden = false
                self.bottomHeightConstraint.constant = self.imageListUserCollectionView.frame.height
                self.view.layoutIfNeeded()
            })
        }
        
        self.indexPath = indexPath
        if let cell = tableView.cellForRow(at: indexPath) as? ListPostedTableViewCell {
            cell.lblCheckbox.text = "✓"
        }
        self.listImage = [String]()
        
        let job = self.listPost[indexPath.row]
        self.jobWillSelecte = job
        let images = job.image?.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").split(separator: ",")
        
        for src in images! {
            self.listImage.append(String(src))
        }
        self.imageListUserCollectionView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? ListPostedTableViewCell {
            cell.lblCheckbox.text = ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0.15 * UIScreen.main.bounds.height
    }
    func formatDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateCutrent = dateFormatter.date(from: date)
        let day = Calendar.current.component(.day, from: dateCutrent!) < 10 ? "0\(Calendar.current.component(.day, from: dateCutrent!))" : "\(Calendar.current.component(.day, from: dateCutrent!))"
        let month = Calendar.current.component(.month, from: dateCutrent!) < 10 ? "0\(Calendar.current.component(.month, from: dateCutrent!))" : "\(Calendar.current.component(.month, from: dateCutrent!))"
        let year = Calendar.current.component(.year, from: dateCutrent!)
        let hour = Calendar.current.component(.hour, from: dateCutrent!) < 10 ? "0\(Calendar.current.component(.hour, from: dateCutrent!))" : "\(Calendar.current.component(.hour, from: dateCutrent!))"
        let minute = Calendar.current.component(.minute, from: dateCutrent!) < 10 ? "0\(Calendar.current.component(.minute, from: dateCutrent!))" : "\(Calendar.current.component(.minute, from: dateCutrent!))"
        return "\(day)-\(month)-\(year) \(hour):\(minute)"
    }
}

extension ListPostedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
        let image = self.listImage[indexPath.row]
        
        SKActivityIndicator.show("Đang tải ảnh", userInteractionStatus: true)
        cell.imageOfUserImage.sd_setImage(with: URL(string: url + image)!, completed: { (image, error, type, url) in
            SKActivityIndicator.dismiss()
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ImageDetail.dataFromUser = [String]()
        for src in self.listImage {
            ImageDetail.dataFromUser.append(url + src)
        }
        
        ImageDetail.currentWillSelect = indexPath.row
        let viewNib = Bundle.main.loadNibNamed("ImageDetail", owner: self, options: nil)?[0] as! ImageDetail
        Utils.animateIn(view: viewNib)
        viewNib.frame = (UIApplication.shared.delegate?.window??.bounds)!
        UIApplication.shared.delegate?.window??.addSubview(viewNib)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/4, height: collectionView.frame.height)
    }
}

extension ListPostedViewController: Edit {
    func edit(index: Int) {

    }
}

