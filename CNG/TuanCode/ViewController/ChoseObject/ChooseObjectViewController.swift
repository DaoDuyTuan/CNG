//
//  ChooseObjectViewController.swift
//  CNG
//
//  Created by Duy Tuan on 6/27/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

class ChooseObjectViewController: UIViewController {

    private var isJob = false
    private var previousIndexSection0: IndexPath?
    private var previousIndexSection1: IndexPath?
    
    @IBOutlet weak var btnObjectBar: UITabBarItem!
    @IBOutlet weak var objectTableView: UITableView!
    private var area1 = ["Cơ điện", "Xây dựng", "Nội thất"]
    private var area2 = ["Thi công", "Mua bán", "Tìm đối tác", "Tìm đội thợ", "Tuyển dụng(đối tượng là kỹ sư"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibCell = UINib(nibName: "ObjectCellTableViewCell", bundle: nil)
        self.objectTableView.register(nibCell, forCellReuseIdentifier: "chooseObject")
        
    }
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ChooseObjectViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return area1.count
        }
        return area2.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chooseObject", for: indexPath) as! ObjectCellTableViewCell
        cell.lblChoose.tag = indexPath.section
        cell.lblChoose.layer.cornerRadius = cell.lblChoose.frame.height/2
        cell.lblChoose.clipsToBounds = true
        
        switch indexPath.section {
        case 0:
            cell.titleObject.tag = indexPath.row
            cell.titleObject.text = area1[indexPath.row]
        case 1:
            cell.titleObject.tag = indexPath.row
            cell.titleObject.text = area2[indexPath.row]
        default:
            print("dao duy tuan")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ObjectCellTableViewCell
        cell.selectionStyle = .none
        switch indexPath.section {
        case 0:
            postJob.categoryID = "\(indexPath.row + 1)"
            if let previous = self.previousIndexSection0 {
                tableView.deselectRow(at: previous, animated: true)
                let cell1 = tableView.cellForRow(at: previous) as! ObjectCellTableViewCell
                cell1.lblChoose.layer.backgroundColor = UIColor.white.cgColor
            }
            self.previousIndexSection0 = indexPath
        case 1:
            postJob.jobID = "\(indexPath.row + 1)"
            if let previous = self.previousIndexSection1 {
                tableView.deselectRow(at: previous, animated: true)
                let cell2 = tableView.cellForRow(at: previous) as! ObjectCellTableViewCell
                cell2.lblChoose.layer.backgroundColor = UIColor.white.cgColor
            }
            self.previousIndexSection1 = indexPath
        default:
            print("dao duy tuan")
        }
        
        cell.lblChoose.layer.backgroundColor = UIColor.red.cgColor
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ObjectCellTableViewCell
        switch indexPath.section {
        case 0:
            if indexPath.section == 0 {
                if !self.isJob {
                    cell.lblChoose.layer.backgroundColor = UIColor.white.cgColor
                } else {
                    cell.lblChoose.layer.backgroundColor = UIColor.red.cgColor
                }
            }
        case 1:
            if self.isJob {
                cell.lblChoose.layer.backgroundColor = UIColor.white.cgColor
            } else {
                cell.lblChoose.layer.backgroundColor = UIColor.red.cgColor
            }
        default:
            print("dao duy tuan")
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch indexPath.section {
        case 0:
            self.isJob = false
        case 1:
            self.isJob = true
        default:
            print("dao duy tuan")
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Ngành nghề"
        }
        return "Mảng"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

