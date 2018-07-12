//
//  Category.swift
//  CNG
//
//  Created by Quang on 5/15/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

class Category: NSObject {
    
    var category_name: String?
    var countCategory: Int?
    
    init(data: [String: Any]) {
        self.category_name = data["category_name"] as? String
        self.countCategory = data["countCategory"] as? Int
    }
    
    init(category_name: String, countCategory: Int) {
        self.countCategory = countCategory
        self.category_name = category_name
    }
    
}
