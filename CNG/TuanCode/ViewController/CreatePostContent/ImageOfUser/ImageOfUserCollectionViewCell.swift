//
//  ImageOfUserCollectionViewCell.swift
//  CNG
//
//  Created by Duy Tuan on 7/2/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

protocol RemoveImage: class {
    func deleteImage(index: Int)
}
class ImageOfUserCollectionViewCell: UICollectionViewCell {

    weak var delegate: RemoveImage!
    @IBOutlet weak var btnDelegate: UIButton!
    @IBOutlet weak var imageOfUser: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBAction func removeImage(_ sender: UIButton) {
        self.delegate.deleteImage(index: sender.tag)
    }
}
