//
//  ChooseAreaViewController.swift
//  CNG
//
//  Created by Duy Tuan on 6/27/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

class ChooseAreaViewController: UIViewController {

    @IBOutlet weak var btnAreaBar: UITabBarItem!
    private let areaList = ["Hà Nội", "HCM", "An Giang", "Bà Rịa - Vũng Tàu", "Bắc Giang", "Bắc Kạn", "Bạc Liêu", "Bắc Ninh", "Bến tre", "Bến Tre", "Bình Dương", "Bình Định", "Bình Thuận", "Cà Mau", "Cao Bằng", "Cao Bằng", "Đăk Lắk", "Đắk Nông", "Điện Biên", "Đông Nai", "Đồng Tháp", "Gia Lai", "Hà Giang", "Hoà Bình", "Hưng Yên", "Khánh Hoà", "Kiên Giang", "Kon Tum", "Lai Châu", "Lâm Đồng", "Lạng Sơn", "Lào Cai", "Long An", "Nam Định", "Nghệ An", "Ninh Bình", "Ninh Thuận" ,"Phú Thọ", "Quảng Bình", "Quảng Nam", "Quảng Ngại", "Quảng Trị", "Sóc Trăng", "Sơn La", "Tây Ninh", "Thái Bình", "Thái Nguyên", "Thanh Hoá", "Thừa Thiên Huế", "Tiền Giang", "Trà Vinh", "Tuyên Quang", "Vĩnh Long", "Vĩnh Phúc", "Yên Bái", "Phú Yên", "Cần Thơ"]
    private var selectedArea: [String] = []
    @IBOutlet weak var searchArea: UIView!
    @IBOutlet weak var areaTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUIArea()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUIArea() {
        self.searchArea.layer.shadowOffset = CGSize(width: 0.5, height: 4.0)
        self.searchArea.layer.shadowColor = UIColor.black.cgColor
        self.searchArea.layer.shadowOpacity = 0.5
        self.searchArea.layer.shadowRadius = 3.0
        self.searchArea.layer.masksToBounds = false
        
        let nibCell = UINib(nibName: "ObjectCellTableViewCell", bundle: nil)
        self.areaTableView.register(nibCell, forCellReuseIdentifier: "chooseObject")
    }
    @IBAction func post(_ sender: Any) {        
        postJob.user = user
        postJob.address = self.selectedArea
        let param = ["postBy": postJob.user.name!,
                     "message": postJob.message!,
                     "img": postJob.img ?? "",
                     "postWall": "\(postJob.user.facebook!)",
                     "address": self.convertArrayToJson(array: postJob.address!)!,
                     "phoneNumber": postJob.user.phone!]  as [String: Any]
        
        PostAPI.createPost(user: user, post: postJob, param: param, image: postJob.img!)
    }
    
    func convertArrayToJson(array: [String]) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: array, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
}

extension ChooseAreaViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.areaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chooseObject", for: indexPath) as! ObjectCellTableViewCell
        cell.titleObject.text = self.areaList[indexPath.row]
        if let _ = self.getIndexInSelectedArea(area: self.areaList[indexPath.row]) {
            cell.lblChoose.text = "✓"
        } else {
            cell.lblChoose.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ObjectCellTableViewCell
            if let index = self.getIndexInSelectedArea(area: self.areaList[indexPath.row]) {
            self.selectedArea.remove(at: index)
            cell.lblChoose.text = ""
        } else {
            cell.lblChoose.text = "✓"
            self.selectedArea.append(self.areaList[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Danh sách các khu vực"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

extension ChooseAreaViewController{
    private func getIndexInSelectedArea(area: String) -> Int? {
        let indexOf = self.selectedArea.index(of: area)
        return indexOf
    }
}
