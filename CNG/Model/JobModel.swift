//
//  JobModel.swift
//  CNG
//
//  Created by Quang on 05/05/2018.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

class JobModel: NSObject {

    var oder_id: Int?
    var message: String?
    var category_id: Int?
    var job_id: Int?
    var postLink: String?
    var postBy: String?
    var postWall: String?
    var phoneNumber: String?
    var email: String?
    var address: String?
    var postDate: String?
    var job_name: String?
    var category_name: String?
    var byGroup: String?
    var linkGroup: String?
    var count_favorite: Int?
    var count_approach: Int?
    var image: String?
    var isLoadFromFirbase = false
    var isImageLoaded = false
    
    init(data: [String: Any]) {
        self.oder_id = data["oder_id"] as? Int
        self.message = data["message"] as? String
        self.category_id = data["category_id"] as? Int
        self.job_id = data["job_id"] as? Int
        self.postLink = data["postLink"] as? String
        self.postBy = data["postBy"] as? String
        self.postWall = data["postWall"] as? String
        self.phoneNumber = data["phoneNumber"] as? String
        self.email = data["email"] as? String
        self.address = data["address"] as? String
        self.postDate = data["postDate"] as? String
        self.job_name = data["job_name"] as? String
        self.category_name = data["category_name"] as? String
        self.byGroup = data["byGroup"] as? String
        self.linkGroup = data["linkGroup"] as? String
        self.count_favorite = data["count_favorite"] as? Int
        self.count_approach = data["count_approach"] as? Int
        self.image = data["image"] as? String
    }
    override init() {
        
    }
}
