//
//  ObjectCellTableViewCell.swift
//  CNG
//
//  Created by Duy Tuan on 6/27/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

protocol GetObjectInfo: class {
    func getObject(section: Int)
}
class ObjectCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleObject: UILabel!
    @IBOutlet weak var lblChoose: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblChoose.layer.borderWidth = 2.0
        lblChoose.layer.cornerRadius = 5.0
        lblChoose.clipsToBounds = true
    }
}
