//
//  CountJob.swift
//  CNG
//
//  Created by Quang on 5/10/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

class CountJob: NSObject {

    var job_id: Int?
    var job_name: String?
    var countJob: Int?
    
    init(data: [String: Any]) {
        self.job_id = data["job_id"] as? Int
        self.job_name = data["job_name"] as? String
        self.countJob = data["countJob"] as? Int
    }
    
    init(job_id: Int, job_name: String, countJob: Int) {
        self.job_id = job_id
        self.job_name = job_name
        self.countJob = countJob
    }
    
}
