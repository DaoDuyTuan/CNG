//
//  UserModel.swift
//  CNG
//
//  Created by Quang on 04/05/2018.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

class UserModel: NSObject {

    var id: String?
    var name: String?
    var facebook: String?
    var phone: String?
    var city: String?
    var email: String?
    var kind: String?
    var job: String?
    var sex: String?
    var birth: String?
    
    override init() {
        
    }
    
    init(data: [String: Any]) {
        id = data["id"] as? String
        name = data["name"] as? String
        facebook = data["facebook"] as? String
        phone = data["phone"] as? String
        city = data["city"] as? String
        email = data["email"] as? String
        kind = data["kind"] as? String
        job = data["job"] as? String
        sex = data["sex"] as? String
        birth = data["birth"] as? String
    }
    
    init(data: [String: Any], type: Bool) {
        id = "\((data["user_id"] as? Int)!)"
        name = data["user_name"] as? String
        facebook = data["url_facebook"] as? String
        phone = data["user_phone"] as? String
        city = data["user_city"] as? String
        email = data["user_email"] as? String
        kind = data["user_kind"] as? String
        job = data["user_job"] as? String
        sex = data["user_sex"] as? String
        birth = data["user_birth"] as? String
    }
    
    init(id: String, name: String, facebook: String, phone: String, city: String, email: String, kind: String, job: String, sex: String, birth: String) {
        self.id = id
        self.facebook = facebook
        self.phone = phone
        self.city = phone
        self.email = phone
        self.kind = phone
        self.job = phone
        self.sex = phone
        self.birth = phone
    }
    
    func toDictionary() -> [String: String] {
        return ["id": id!,
                "name": name!,
                "facebook": facebook!,
                "phone": phone!,
                "city": city!,
                "email": email!,
                "kind": kind!,
                "job": job!,
                "sex": sex!,
                "birth": birth!]
    }
    
    static var userCache : [String:Any]?  {
        get {
            if let value = UserDefaults.standard.value(forKey: "KEY_USER_CACHE") {
                return value as? [String:Any]
            }
            return nil
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "KEY_USER_CACHE")
            UserDefaults.standard.synchronize()
        }
    }
    
}
