//
//  JobNotImageCellTableViewCell.swift
//  CNG
//
//  Created by Duy Tuan on 7/6/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

class JobNotImageCellTableViewCell: UITableViewCell {

    @IBOutlet weak var lblSaveOrDelete: UILabel!
    @IBOutlet weak var iconSaveOrDelete: UIImageView!
    @IBOutlet weak var btnSaveOrDelete: UIButton!
    @IBOutlet var tools: [UIButton]!
    @IBOutlet weak var lblNameUser: UILabel!
    @IBOutlet weak var lblFollow: UILabel!
    @IBOutlet weak var lblDatePost: UILabel!
    @IBOutlet weak var lblContentPost: UILabel!
    @IBOutlet weak var showImageCount: UILabel!
    @IBOutlet weak var lblShowCountImage: UILabel!
    var selectionDelegate: SelectAction!
    var job: JobModel?
    @IBOutlet var setImageOfUser: [UIImageView]!
    var srcList = [String]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        for button in tools {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(displayP3Red: 184/255, green: 184/255, blue: 184/255, alpha: 1).cgColor
        }
    }
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
    
    @IBAction func showImageDetail(_ sender: UIButton) {
//        ImageDetail.imageListUser = [UIImage]()
//        if self.setImageOfUser.count > 0 {
//            for image in self.setImageOfUser {
//                if let img = image.image {
//                    ImageDetail.imageListUser.append(img)
//                }
//            }
//        }
        if let image = self.job?.image {
            let images = image.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").split(separator: ",")
            for src in images {
                ImageDetail.dataFromUser.append(url + String(src))
            }
        }
        
        ImageDetail.currentWillSelect = sender.tag
        let viewNib = Bundle.main.loadNibNamed("ImageDetail", owner: self, options: nil)?[0] as! ImageDetail
        Utils.animateIn(view: viewNib)
        viewNib.frame = (UIApplication.shared.delegate?.window??.bounds)!
        UIApplication.shared.delegate?.window??.addSubview(viewNib)
    }
    
    func addApproach(job: JobModel, completion:@escaping (Int) -> Void) {
        APIManage.shared.addApproach(idJob: "\((job.oder_id!))", idUser: (UserModel(data: UserModel.userCache!).id)!) { (success, count_approach) in
            if success {
                self.lblFollow.text = "(\(job.count_approach != nil ? count_approach : 0) người tiếp cận )"
                completion(count_approach)
            } else {
                completion(count_approach)
            }
        }
    }
}
