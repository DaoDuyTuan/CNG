//
//  PostModel.swift
//  CNG
//
//  Created by Duy Tuan on 7/1/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

class PostModel: NSObject {
    var user: UserModel!
    var categoryID: String?
    var jobID: String?
    var message: String?
    var postBy: String?
    var postWall: String?
    var address: [String]?
    var img: (fileName: [String], data: [Data])?
    
    init(job: JobModel) {
        
    }
    
    override init() {
        
    }
}
