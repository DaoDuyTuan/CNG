//
//  ImageDetail.swift
//  CNG
//
//  Created by Duy Tuan on 7/7/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit
import ImageSlideshow

class ImageDetail: UIView {
    static var currentWillSelect = 0
    static var dataFromUser = [String]()
    static var imageListUser = [UIImage]()
    @IBOutlet weak var slideShow: ImageSlideshow!
    @IBOutlet weak var btnClose: UIButton!
    
    override func awakeFromNib() {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        
        self.btnClose.layer.cornerRadius = self.btnClose.frame.height / 2
        self.btnClose.layer.borderWidth = 1.0
        self.btnClose.layer.borderColor = UIColor.white.cgColor
        
        slideShow.pageIndicator = pageControl
        slideShow.zoomEnabled = true
        slideShow.circular = false
        if ImageDetail.imageListUser.count > 0 {
            var soucre = [ImageSource]()
            for img in ImageDetail.imageListUser {
                soucre.append(ImageSource(image: img))
            }
            self.slideShow.setImageInputs(soucre)
        } else {
            var source = [SDWebImageSource]()
            for img in ImageDetail.dataFromUser.compactMap({$0}) {
                source.append(SDWebImageSource(url: URL(string: img)!))
                
            }
            self.slideShow.setImageInputs(source)
        }
        self.slideShow.setScrollViewPage(ImageDetail.currentWillSelect, animated: true)
    }
    
    
    deinit {
        ImageDetail.imageListUser = [UIImage]()
        ImageDetail.dataFromUser = [String]()
    }
    
    @IBAction func close(_ sender: Any) {
        self.removeFromSuperview()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    @IBOutlet weak var removeView: UIView!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchs: UITouch? = touches.first
        if touchs?.view == self.removeView {
            Utils.animateOut(view: self)
        }
    }
}
