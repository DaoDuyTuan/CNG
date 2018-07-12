//
//  EditButton.swift
//  CNG
//
//  Created by Duy Tuan on 7/10/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

class EditButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitle("Edit", for: .normal)
        self.titleLabel?.text = "Edit"
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
