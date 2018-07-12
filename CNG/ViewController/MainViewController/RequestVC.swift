//
//  RequestViewController.swift
//  CNG
//
//  Created by Quang on 04/05/2018.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit
import DropDown
import YNSearch
import SnapKit
import Floaty
import FirebaseDatabase

let url = "http://150.95.109.183:3000/upload/"
class RequestViewController: UIViewController {
    var ref: DatabaseReference?
    fileprivate var viewNavigationBar: UIView = {
        let view = UIView()
        view.backgroundColor = DColor.grayColor
        return view
    }()
    
    var viewNavigationBarSearch: UIView = {
        let view = UIView(frame: CGRect(x: UIScreen.main.bounds.size.width, y: 20, width: UIScreen.main.bounds.size.width, height: 44))
        view.backgroundColor = DColor.whiteColor
        return view
    }()
    
    var imageViewBackSearch: UIButton = {
        let button = UIButton(frame: CGRect(x: 10, y: 7, width: 30, height: 30))
        let image = UIImage(named: "ic_arrow_back_white")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.contentMode = .scaleToFill
        button.tintColor = DColor.blackColor
        return button
    }()
    
    var textFieldSearch: UITextField = {
        let textField = UITextField(frame: CGRect(x: 64, y: 0, width: UIScreen.main.bounds.size.width - 84, height: 44))
        textField.textColor = DColor.blackColor
        textField.placeholder = "Nhập từ khoá..."
        textField.font = DFont.fontLight(size: 15)
        textField.autocorrectionType = .no;
        textField.textAlignment = NSTextAlignment.left
        return textField
    }()
    
    fileprivate var fillter1: UIButton = {
        let list = UIButton()
        list.layer.cornerRadius = 3
        list.backgroundColor = DColor.whiteColor
        list.setTitle("Tất cả", for: .normal)
        list.setTitleColor(DColor.blackColor, for: .normal)
        list.titleLabel?.font = DFont.fontLight(size: 14)
        return list
    }()
    
    fileprivate var imageFillter1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_arrow_drop_down_36pt")
        imageView.backgroundColor = DColor.whiteColor
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = DColor.blackColor
        imageView.transform = CGAffineTransform(rotationAngle: 0)
        return imageView
    }()
    
    fileprivate var fillter2: UIButton = {
        let list = UIButton()
        list.layer.cornerRadius = 3
        list.backgroundColor = DColor.whiteColor
        list.setTitle("Tất cả", for: .normal)
        list.setTitleColor(DColor.blackColor, for: .normal)
        list.titleLabel?.font = DFont.fontLight(size: 14)
        return list
    }()
    
    fileprivate var imageFillter2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_arrow_drop_down_36pt")
        imageView.backgroundColor = DColor.whiteColor
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = DColor.blackColor
        imageView.transform = CGAffineTransform(rotationAngle: 0)
        return imageView
    }()
    
    fileprivate var imageSearch: UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "ic_search"))
        view.contentMode = .scaleToFill
        return view
    }()
    
    fileprivate var tableView: UITableView =  {
        let view = UITableView()
        view.separatorColor = DColor.whiteColor
        return view
    }()
    
    fileprivate let floaty: Floaty = {
        let view = Floaty()
        view.buttonColor = DColor.readColor
        view.buttonImage = UIImage(named: "filter")
        view.buttonImage = view.buttonImage!.withRenderingMode(.alwaysTemplate)
        view.tintColor = DColor.whiteColor
        view.plusColor = DColor.whiteColor
        view.openAnimationType = .slideUp
        return view
    }()
    
    fileprivate var listAddressChoose: [AddressModel]?{
        willSet{
            if (newValue?.count)! > 1 {
                self.fillter1.setTitle("Nhiều khu vực", for: .normal)
            }else if (newValue?.count)! == 1{
                self.fillter1.setTitle("\((newValue![0].address)!)", for: .normal)
            }else{
                self.fillter1.setTitle("Khu vực", for: .normal)
            }
        }
    }
    fileprivate var listKind = ["Tất cả", "Thi công", "Mua bán", "Tìm đối tác", "Tìm thợ", "Tuyển dụng"]
    
    fileprivate var category: [String]?{
        willSet{
            if (newValue?.count)! > 1 {
                self.fillter2.setTitle("Nhiều hạng mục", for: .normal)
            }else if (newValue?.count)! == 1 {
                self.fillter2.setTitle("\((newValue![0]))", for: .normal)
            } else {
                self.fillter2.setTitle("Hạng mục", for: .normal)
            }
        }
    }
    
    fileprivate var user: UserModel? {
        willSet{
            self.listAddressChoose = SQLiteManger.getInstance().getListAddress()
            self.category = SQLiteManger.getInstance().getListCategory()
            self.kind = newValue?.kind
        }
    }
    
    fileprivate var indexPage: Int = 0
    fileprivate var kind: String?
    
    fileprivate var listJob: [JobModel]?
    
    fileprivate var listJobFavorite: [JobModel]?
    
    fileprivate var textForSearch: String?
    
    fileprivate var isLoadMore: Bool = true
    fileprivate var isSeacrh: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "JobCellTableViewCell", bundle: nil), forCellReuseIdentifier: "JobPostImage")
        self.tableView.register(UINib(nibName: "JobNotImageCellTableViewCell", bundle: nil), forCellReuseIdentifier: "JobPostNotImage")
        initValue()
        addSubView()
        initContrains()
        initActionView()
    }

    fileprivate func validateJobFromNotification() {
        ref = Database.database().reference()
        ref?.child("fboders").queryLimited(toLast: 1).observe(.childAdded, with: { snapshot in
            let job = JobModel(data: snapshot.value as! [String : Any])
            
            guard let orderID = job.oder_id, let categoryJob = job.category_name, let address = job.address, let name = job.job_name else {
                return
            }
            
            if (self.listAddressChoose?.filter({ $0.address! == address }).count)! > 0 {
                if (self.listJob?.count)! > 0, orderID != self.listJob?[0].oder_id {
                    for categoryN in self.category! {
                        if categoryN == categoryJob {
                            if self.kind == name {
                                job.isLoadFromFirbase = true
                                self.listJob?.insert(job, at: 0)
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.user = UserModel(data: UserModel.userCache!)
        self.getAllJob()
        APIManage.shared.getCountJob(address: SQLiteManger.getInstance().getListAddress(), category: SQLiteManger.getInstance().getListCategory()) { (success, listCountJob) in
            if success {
                self.initFloatingButton(listCountJob: listCountJob)
            }
        }
    }

    func getAllJob() {
        APIManage.shared.getJobOfAddressKind(address: self.listAddressChoose!, category: self.category!, start: self.indexPage, job_name: self.kind!, user_id: (self.user?.id)!) { (success, listJob) in
            if success {
                self.listJob = listJob
                APIManage.shared.getListFavorite(idUser: UserModel.init(data: UserModel.userCache!).id!) { (success, listJob) in
                    if success {
                        self.listJobFavorite = listJob
                        for job in self.listJobFavorite! {
                            for i in 0..<self.listJob!.count {
                                if job.oder_id == self.listJob![i].oder_id {
                                    self.listJob?.remove(at: i)
                                    break
                                }
                            }
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func initValue() {
        
        // Action triggered on selection

    }
    
    fileprivate func addSubView(){
        self.view.addSubview(viewNavigationBar)
        self.view.addSubview(viewNavigationBarSearch)
        self.viewNavigationBar.addSubview(fillter1)
        self.viewNavigationBar.addSubview(imageFillter1)
        self.viewNavigationBar.addSubview(fillter2)
        self.viewNavigationBar.addSubview(imageFillter2)
        self.viewNavigationBar.addSubview(imageSearch)
        self.viewNavigationBarSearch.addSubview(imageViewBackSearch)
        self.viewNavigationBarSearch.addSubview(textFieldSearch)
        self.view.addSubview(tableView)
        self.view.addSubview(self.floaty)
    }
    
    fileprivate func initContrains(){
        
        initContrainsNavigationBar()
        
        self.tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().offset(0)
            make.top.equalTo(self.viewNavigationBar.snp.bottom).offset(0)
            make.bottom.equalToSuperview().offset(UIDevice.tabbar.rawValue)
        }
    }
    
    fileprivate func initContrainsNavigationBar(){
        self.viewNavigationBar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview().offset(0)
            make.height.equalTo(UIDevice.statusBar.rawValue + 44)
        }
        
        self.fillter1.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-5)
            make.top.equalToSuperview().offset(UIDevice.statusBar.rawValue + 5)
            make.width.equalToSuperview().multipliedBy(1.0/2.5)
            make.leading.equalToSuperview().offset(10)
        }
        
        self.imageFillter1.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.width.equalTo(self.imageFillter1.snp.height).multipliedBy(1.0/1.0)
            make.centerY.equalTo(self.fillter1).offset(0)
            make.trailing.equalTo(self.fillter1.snp.trailing).offset(-10)
        }
        
        self.fillter2.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-5)
            make.top.equalToSuperview().offset(UIDevice.statusBar.rawValue + 5)
            make.width.equalToSuperview().multipliedBy(1.0/2.5)
            make.leading.equalTo(self.fillter1.snp.trailing).offset(10)
        }
        
        self.imageFillter2.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.imageFillter1.snp.height).multipliedBy(1.0/1.0)
            make.centerY.equalTo(self.fillter2).offset(0)
            make.trailing.equalTo(self.fillter2.snp.trailing).offset(-10)
        }
        
        self.imageSearch.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.fillter2).offset(0)
            make.leading.equalTo(self.fillter2.snp.trailing).offset(5)
            make.height.width.equalTo(30)
        }
        
    }
    
    fileprivate func initActionView(){
        
        self.imageViewBackSearch.isUserInteractionEnabled = true
        self.imageViewBackSearch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backSearch)))
        
        self.imageSearch.isUserInteractionEnabled = true
        self.imageSearch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backSearch)))
        
        self.textFieldSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.textFieldSearch.addTarget(self, action: #selector(textFieldDid(_:)), for: .editingDidEndOnExit)
        
        fillter1.isUserInteractionEnabled = true
        fillter2.isUserInteractionEnabled = true
        
        self.fillter1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showFilter1)))
        self.fillter2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showFilter2)))
    }

    fileprivate func initFloatingButton(listCountJob: [CountJob]) {
        for item in floaty.items{
            floaty.removeItem(item: item)
        }
        if listCountJob.count > 0 {
            for countJob in listCountJob {
                let item: FloatyItem?
                if countJob.countJob! > 0 {
                    item = createFloatyItem(title: "\(countJob.job_name!)(\((countJob.countJob)!))")
                } else {
                    item = createFloatyItem(title: "\(countJob.job_name!)")
                }
                floaty.addItem(item: item!)
            }
        }
    }
    
    fileprivate func createFloatyItem(title: String) -> FloatyItem{
        let item = FloatyItem()
        item.title = title
        item.titleLabel.font = DFont.fontBold(size: 16)
        item.buttonColor = DColor.readColor
        item.handler = { item in
            if title == "Tất cả" {
                self.kind = ""
            } else {
                self.kind = String(title.split(separator: "(")[0])
            }
            self.indexPage = 0
            self.isLoadMore = true
            self.isSeacrh = false
            
            APIManage.shared.getJobOfAddressKind(address: (self.listAddressChoose!), category: (self.category!), start: (self.indexPage), job_name: (self.kind!), user_id: (self.user?.id)!) { (success, listJob) in
                if success {
                    self.listJob = listJob
                    for job in (self.listJobFavorite!) {
                        for i in 0..<(self.listJob!.count) {
                            if job.oder_id == self.listJob![i].oder_id {
                                self.listJob?.remove(at: i)
                                break
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
        return item
    }
    
    @objc func backSearch() {
        if self.viewNavigationBarSearch.layer.frame.origin.x == UIScreen.main.bounds.size.width{
            UIView.animate(withDuration: 0.3, animations: {self.viewNavigationBarSearch.layer.frame.origin.x = 0})
            self.textFieldSearch.text = ""
            self.textForSearch = ""
        }else{
            UIView.animate(withDuration: 0.3, animations: {self.viewNavigationBarSearch.layer.frame.origin.x = UIScreen.main.bounds.size.width})
            view.endEditing(true)
            self.textFieldSearch.text = ""
            self.textForSearch = ""
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.textForSearch = textField.text!
    }
    
    @objc func textFieldDid(_ textField: UITextField) {
        view.endEditing(true)
        self.indexPage = 0
        self.isLoadMore = true
        self.isSeacrh = true
        UIView.animate(withDuration: 0.3, animations: {self.viewNavigationBarSearch.layer.frame.origin.x = UIScreen.main.bounds.size.width})
        APIManage.shared.searchJob(search: self.textForSearch!, start: indexPage) { (success, listJob) in
            if success {
                self.listJob = listJob
                for job in self.listJobFavorite! {
                    for i in 0..<self.listJob!.count {
                        if job.oder_id == self.listJob![i].oder_id {
                            self.listJob?.remove(at: i)
                            break
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func showFilter1(){
        let vc = SelectAddressViewController()
        vc.listAddressCurrent = self.listAddressChoose
        vc.addressSelect = {(address) in
            if address == self.listAddressChoose {
                return
            } else {
                self.listAddressChoose = address
                self.indexPage = 0
                self.isLoadMore = true
                self.isSeacrh = false
                APIManage.shared.getJobOfAddressKind(address: self.listAddressChoose!, category: self.category!, start: self.indexPage, job_name: self.kind!, user_id: (self.user?.id)!) { (success, listJob) in
                    if success {
                        self.listJob = listJob
                        for job in self.listJobFavorite! {
                            for i in 0..<self.listJob!.count {
                                if job.oder_id == self.listJob![i].oder_id {
                                    self.listJob?.remove(at: i)
                                    break
                                }
                            }
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func showFilter2(){
        let vc = SelectCategoryVC()
        vc.listCategoryCurrent = self.category
        vc.categorySelect = { (listCategory) in
            self.category = listCategory
            self.indexPage = 0
            self.isLoadMore = true
            self.isSeacrh = false
            APIManage.shared.getJobOfAddressKind(address: (self.listAddressChoose!), category: (self.category!), start: (self.indexPage), job_name: (self.kind!), user_id: (self.user?.id)!) { (success, listJob) in
                if success {
                    self.listJob = listJob
                    for job in (self.listJobFavorite!) {
                        for i in 0..<(self.listJob!.count) {
                            if job.oder_id == self.listJob![i].oder_id {
                                self.listJob?.remove(at: i)
                                break
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func addListFavorite(job: JobModel) {
        APIManage.shared.addListFavorite(idJob: "\((job.oder_id!))", idUser: (self.user?.id)!) { (success) in
            if success {
                for i in 0..<self.listJob!.count {
                    if job.oder_id == self.listJob![i].oder_id {
                        self.listJob?.remove(at: i)
                        self.listJobFavorite?.append(job)
                        break
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
}

extension RequestViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listJob == nil ? 0 : (self.listJob?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let job = self.listJob![indexPath.row]
            if let image = job.image {
                let cell = tableView.dequeueReusableCell(withIdentifier: "JobPostNotImage", for: indexPath) as! JobNotImageCellTableViewCell
                cell.job = job
                cell.lblNameUser.tag = indexPath.row
                cell.lblNameUser.text = job.postBy
                cell.lblFollow.text = "(\(job.count_approach != nil ? job.count_approach! : 0) người tiếp cận )"
                cell.lblContentPost.text = job.message
                cell.btnSaveOrDelete.tag = 0
                cell.selectionDelegate = self
                
                if job.isLoadFromFirbase {
                    cell.lblDatePost.text = "\(job.postDate!) \((job.category_name)!) \((job.job_name)!)"
                } else {
                    cell.lblDatePost.text = "\(RequestViewController.formatDate(date: job.postDate!))  \((job.address)!) \((job.category_name)!) \((job.job_name)!)"
                }
                
                let images = image.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").split(separator: ",")
                
                if images.count > 3 {
                    cell.showImageCount.isHidden = false
                    cell.lblShowCountImage.text = "+\(images.count - 3)"
                } else {
                    cell.showImageCount.isHidden = true
                    cell.lblShowCountImage.isHidden = true
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
                
                for (index, src) in images.enumerated() {
                    cell.setImageOfUser[index].isHidden = false
                    cell.setImageOfUser[index].sd_setImage(with: URL(string: url + src), completed: nil)
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "JobPostImage", for: indexPath) as! JobCellTableViewCell
                cell.job = job
                cell.selectionDelegate = self
                cell.lblNameUser.tag = indexPath.row
                cell.lblNameUser.text = job.postBy
                cell.lblFollow.text = "(\(job.count_approach != nil ? job.count_approach! : 0) người tiếp cận )"
                cell.lblContentPost.text = job.message
                cell.btnSaveOrDelete.tag = 0
                if job.isLoadFromFirbase {
                    cell.lblDatePost.text = "\(job.postDate!) (\((job.category_name)!) \((job.job_name)!)"
                } else {
                    cell.lblDatePost.text = "\(RequestViewController.formatDate(date: job.postDate!))  \((job.address)!) \((job.category_name)!) \((job.job_name)!)"
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
        if self.isLoadMore && indexPath.row == ((self.listJob?.count)! - 1){
            self.indexPage = (self.listJob?.count)! + 1
            if self.isSeacrh == false {
                APIManage.shared.getJobOfAddressKind(address: self.listAddressChoose!, category: self.category!, start: self.indexPage, job_name: self.kind!, user_id: (self.user?.id)!) { (success, listJob) in
                    if success {
                        if listJob.count > 0 {
                            for job in listJob {
                                self.listJob?.append(job)
                            }
                            for job in self.listJobFavorite! {
                                for i in 0..<self.listJob!.count {
                                    if job.oder_id == self.listJob![i].oder_id {
                                        self.listJob?.remove(at: i)
                                        break
                                    }
                                }
                            }
                            self.tableView.reloadData()
                            self.isLoadMore = true
                        }
                    }
                }
            } else {
                APIManage.shared.searchJob(search: self.textForSearch!, start: indexPage) { (success, listJob) in
                    if success {
                        if listJob.count > 0 {
                            for job in listJob {
                                self.listJob?.append(job)
                            }
                            for job in self.listJobFavorite! {
                                for i in 0..<self.listJob!.count {
                                    if job.oder_id == self.listJob![i].oder_id {
                                        self.listJob?.remove(at: i)
                                        break
                                    }
                                }
                            }
                            self.tableView.reloadData()
                            self.isLoadMore = true
                        }
                    }
                }
            }
        }
    }

}

extension RequestViewController: SelectAction {
    
    func actionDelete(job: JobModel) {
        
    }
    
    func actionDetail(job: JobModel, index: Int) {
        if job.byGroup != nil {
            let dialog = CustomDialogJobDetail()
            dialog.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            dialog.job = job
            dialog.participationSelect = { () in
                if let checkURL = NSURL(string: job.linkGroup!) {
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
        UIApplication.shared.open(number)
    }
    
    func actionFavorite(job: JobModel, index: Int) {
        self.updateMainJobList(job: job, index: index)
        addListFavorite(job: job)
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

extension RequestViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RequestViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    static func formatDate(date: String) -> String {
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
