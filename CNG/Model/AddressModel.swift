//
//  AddressModel.swift
//  CNG
//
//  Created by Quang on 5/10/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

class AddressModel: NSObject {

    var address: String?
    var countJob: Int?
    
    override init() {
        super.init()
    }
    
    init(data: [String: Any]) {
        self.countJob = data["countJob"] as? Int
        self.address = data["address"] as? String
    }
    
    init( address: String, countJob: Int) {
        self.countJob = countJob
        self.address = address
    }
    
}
