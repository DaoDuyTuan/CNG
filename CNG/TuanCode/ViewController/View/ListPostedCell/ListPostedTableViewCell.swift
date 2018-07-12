//
//  ListPostedTableViewCell.swift
//  CNG
//
//  Created by Duy Tuan on 7/11/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit
protocol Edit: class {
    func edit(index: Int)
}
class ListPostedTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCheckbox: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    weak var delegateEditPost: Edit!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userImageView.layer.cornerRadius = self.userImageView.bounds.size.width / 2
        
        self.lblCheckbox.layer.cornerRadius = self.lblCheckbox.bounds.size.width / 2
        self.lblCheckbox.layer.borderWidth = 1.0
        self.lblCheckbox.layer.borderColor = UIColor.black.cgColor
        self.lblCheckbox.clipsToBounds = true
        self.lblCheckbox.layer.masksToBounds = false
        // Initialization code
        
    }
    
//    @IBAction func checkEdit(_ sender: UIButton) {
////        sender.setTitle("✓", for: .normal)
//        self.delegateEditPost.edit(index: sender.tag)
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
