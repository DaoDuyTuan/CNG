//
//  JobCellTableViewCell.swift
//  CNG
//
//  Created by Duy Tuan on 7/6/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

class JobCellTableViewCell: UITableViewCell {
    @IBOutlet weak var lblSaveOrDelete: UILabel!
    @IBOutlet weak var iconSaveOrDelete: UIImageView!
    @IBOutlet weak var btnSaveOrDelete: UIButton!
    @IBOutlet var tools: [UIButton]!
    @IBOutlet weak var lblNameUser: UILabel!
    @IBOutlet weak var lblFollow: UILabel!
    @IBOutlet weak var lblDatePost: UILabel!
    @IBOutlet weak var lblContentPost: UILabel!
    var selectionDelegate: SelectAction!
    var job: JobModel?
    @IBOutlet var setImageOfUser: [UIImageView]!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        for button in tools {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(displayP3Red: 184/255, green: 184/255, blue: 184/255, alpha: 1).cgColor
        }
    }
    
    override func prepareForReuse() {
//        self.lblNameUser.text = nil
//        self.lblFollow.text = nil
//        self.lblDatePost.text = nil
//        self.lblContentPost.text = nil
//        self.lblSaveOrDelete.text = nil
//        self.iconSaveOrDelete = nil
//        self.setImageOfUser = nil
//        self.job = nil
    }
    @IBOutlet weak var viewFBDetail: UIButton!
    @IBAction func viewFBDetail(_ sender: Any) {
        addApproach(job: self.job!) { count in
            self.job?.count_approach = count
            self.selectionDelegate?.actionDetail(job: self.job!, index: self.lblNameUser.tag)
        }
    }
    
    @IBAction func callNow(_ sender: Any) {
        addApproach(job: self.job!) { count in
            self.job?.count_approach = count
            self.selectionDelegate?.actionCall(job: self.job!, index: self.lblNameUser.tag)
        }
    }
    @IBAction func save(_ sender: UIButton) {
        if sender.tag == 0 {
            addApproach(job: self.job!) { count in
                self.job?.count_approach = count
                self.selectionDelegate?.actionFavorite(job: self.job!, index: self.lblNameUser.tag)
            }
        } else if sender.tag == 1 {
            self.selectionDelegate.actionDelete(job: self.job!)
        }
    }
    
    @IBAction func share(_ sender: Any) {
        addApproach(job: self.job!) { count in
            self.job?.count_approach = count
            self.selectionDelegate?.actionShare(job: self.job!, index: self.lblNameUser.tag)
        }
    }
    @IBAction func sendMessenger(_ sender: Any) {
        addApproach(job: self.job!) { count in
            self.job?.count_approach = count
            self.selectionDelegate?.actionMessage(job: self.job!, index: self.lblNameUser.tag)
        }
    }
    
    func addApproach(job: JobModel, completion:@escaping (Int) -> Void) {
        APIManage.shared.addApproach(idJob: "\((job.oder_id!))", idUser: (UserModel(data: UserModel.userCache!).id)!) { (success, count_approach) in
            if success {
                self.lblFollow.text = "(\(job.count_approach != nil ? count_approach : 0) người tiếp cận )"
                completion(count_approach)
            } else {
                completion(1)
            }
        }
    }
}
