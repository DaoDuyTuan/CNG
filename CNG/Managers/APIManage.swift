//
//  APIManage.swift
//  CNG
//
//  Created by Quang on 04/05/2018.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

fileprivate let STATUS_OK = "00"
fileprivate let STATUS_OK_UPDATE_PROFILE_SUCCESS = "Bạn đã update profile thành công"

let INDEX_CANT_LOADMORE = -1

fileprivate enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

fileprivate enum DAPIDefine : String {
    case updateProfile = "/update_profile"
    case user = "/user"
    case address = "/address"
    case jobOfAddressKind = "/job_of_address_kind"
    case listFavorite = "/listFavorite"
    case favorite = "/favorite"
    case approach = "/approach"
    case deleteFavorite = "/deleteFavorite"
    case searchJob = "/searchJob"
    case category = "/category"
    case getCountJob = "/getCountJob"
    case get_job_user = "/get_job_user"
    func url() -> String {
        let HOST = "http://150.95.109.183:3000/api"
        return HOST + self.rawValue
    }
}

typealias Completion = (_ succes: Bool, _ data: Any?) -> ()

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class APIManage: NSObject {
    fileprivate var queue:OperationQueue?
    fileprivate var listURLDownload:[URL] = []
    
    private let TIMEOUT_REQUEST:TimeInterval = 30
    
    //MARK: Shared Instance
    static let shared:APIManage = APIManage()
    
    //MAKR: private
    fileprivate func request(urlString: String,
                             param: [String: Any]?,
                             method: HTTPMethod,
                             complete: Completion?)
    {
        self.request(urlString: urlString, param: param, method: method, showLoading: true, complete: complete)
    }
    
    fileprivate func request(urlString: String,
                             param: [String: Any]?,
                             method: HTTPMethod,
                             showLoading: Bool,
                             complete: Completion?)
    {
        
        if !UtilManage.isInternetAvailable() {
            
        }
        
        self.displayLoading(showLoading)
        
        var request:URLRequest!
        
        // set method & param
        if method == .get {
            if let parameterString = param?.stringFromHttpParameters() {
                request = URLRequest(url: URL(string:"\(urlString)?\(parameterString)")!)
            }
            else {
                request = URLRequest(url: URL(string:urlString)!)
            }
        }
        else if method == .post {
            request = URLRequest(url: URL(string:urlString)!)
            
            // content-type
            //let headers: Dictionary = ["Content-Type": "application/json"]
            let headers: Dictionary = ["Content-Type": "application/x-www-form-urlencoded"]
            request.allHTTPHeaderFields = headers
            
            let parameterString = param?.stringFromHttpParameters()
            if parameterString != nil {
                request.httpBody = parameterString?.data(using: .utf8)
                BLogInfo(parameterString!)
            }
        }
        
        request.timeoutInterval = TIMEOUT_REQUEST
        request.httpMethod = method.rawValue
        
        //
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            self.hideLoading(showLoading)
            
            // check for fundamental networking error
            guard let data = data, error == nil else {
                if let block = complete {
                    DispatchQueue.main.async {
                        block(false, error)
                    }
                }
                
                return
            }
            
            // check for http errors
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200, let res = response {
                BLog("statusCode should be 200, but is \(httpStatus.statusCode)")
                BLog("response = \(res)")
            }
            
            if let block = complete {
                DispatchQueue.main.async {
                    if let json = self.dataToJSON(data: data) {
                        BLog("response json = \(json)")
                        block(true, json)
                    }
                    else if let responseString = String(data: data, encoding: .utf8) {
                        BLog("response string = \(responseString)")
                        block(true, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    private func dataToJSON(data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: [])
        } catch let myJSONError {
            BLog("convert to json error: \(myJSONError)")
        }
        return nil
    }
    
    private func displayLoading(_ allow:Bool) {
        if allow {
            if let view = UIApplication.shared.keyWindow {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to:view , animated: true)
                }
            }
        }
    }
    
    private func hideLoading(_ allow:Bool) {
        if allow {
            DispatchQueue.main.async {
                if let view = UIApplication.shared.keyWindow {
                    MBProgressHUD.hide(for:view , animated: true)
                }
            }
        }
    }
    //MARK: public
}

//MARK: API for user define
extension APIManage {
    /// API getListCar
    func updateProfile(user: UserModel, complete: @escaping (Bool) -> ())
    {
        let url = DAPIDefine.updateProfile.url()
        let param:[String:Any]? = ["id": user.id!, "name": user.name!, "facebook": user.facebook!, "phone": user.phone!, "city": user.city!, "email": user.email!, "kind": user.kind!, "job": user.job!, "sex": user.sex!, "birth": user.birth!]
        
        request(urlString: url, param: param, method: .post, showLoading: true) { (success, data) in
            if let data_new = data as? [String: Any] {
                if (data_new["message"] as! String) == STATUS_OK_UPDATE_PROFILE_SUCCESS {
                    complete(true)
                    return
                }
            }
            complete(success)
        }
    }
    
    func getAddress(complete: @escaping (Bool, [AddressModel]) -> ())
    {
        let url = DAPIDefine.address.url()
        let param:[String:Any]? = nil
        
        request(urlString: url, param: param, method: .get, showLoading: false) { (success, data) in
            if let data_new = data as? [[String: Any]] {
                var result: [AddressModel] = []
                result.append(AddressModel(address: "Khu vực", countJob: -1))
                data_new.forEach({ (value) in
                    result.append(AddressModel(data: value))
                })
                complete(true, result)
                return
            }
            complete(success, [])
        }
    }
 
    func getJobOfAddressKind(address: [AddressModel], category: [String], start: Int, job_name: String, user_id: String, complete: @escaping (Bool, [JobModel]) -> ())
    {
        let url = DAPIDefine.jobOfAddressKind.url()
        let param:[String:Any]? = ["address": address, "category": category, "start": start, "job_name": job_name, "user_id": user_id]
        
        request(urlString: url, param: param, method: .post, showLoading: true) { (success, data) in
            if let data_new = data as? [[String: Any]] {
                var result: [JobModel] = []
                data_new.forEach({ (value) in
                    result.append(JobModel(data: value))
                })
                complete(true, result)
                return
            }
            complete(success, [])
        }
    }
    
    func getListFavorite(idUser: String, complete: @escaping (Bool, [JobModel]) -> ())
    {
        let url = "\(DAPIDefine.listFavorite.url())/\(idUser)"
        let param:[String:Any]? = nil
        
        request(urlString: url, param: param, method: .get, showLoading: true) { (success, data) in
            if let data_new = data as? [[String: Any]] {
                var result: [JobModel] = []
                data_new.forEach({ (value) in
                    result.append(JobModel(data: value))
                })
                complete(true, result)
                return
            }
            complete(success, [])
        }
    }
    
    func getJobUser(idUser: String, complete: @escaping (Bool, [JobModel]) -> ())
    {
        let url = "\(DAPIDefine.get_job_user.url())/\(idUser)"
        let param:[String:Any]? = nil
        
        request(urlString: url, param: param, method: .get, showLoading: true) { (success, data) in
            if let data_new = data as? [[String: Any]] {
                var result: [JobModel] = []
                data_new.forEach({ (value) in
                    result.append(JobModel(data: value))
                })
                complete(true, result)
                return
            }
            complete(success, [])
        }
    }
    
    func searchJob(search: String, start: Int, complete: @escaping (Bool, [JobModel]) -> ())
    {
        let url = DAPIDefine.searchJob.url()
        let param:[String:Any]? = ["search": search, "start": start]
        
        request(urlString: url, param: param, method: .post, showLoading: true) { (success, data) in
            if let data_new = data as? [[String: Any]] {
                var result: [JobModel] = []
                data_new.forEach({ (value) in
                    result.append(JobModel(data: value))
                })
                complete(true, result)
                return
            }
            complete(success, [])
        }
    }
    
    func addListFavorite(idJob: String, idUser: String, complete: @escaping (Bool) -> ())
    {
        let url = "\(DAPIDefine.favorite.url())/\(idJob)/\(idUser)"
        let param:[String:Any]? = nil
        
        request(urlString: url, param: param, method: .get, showLoading: true) { (success, data) in
            if let data_new = data as? [String: Any] {
                if data_new["message"] as! String == "Bạn đã thêm công việc này vào danh sách tiếp cận"{
                    complete(true)
                    return
                }else{
                    complete(false)
                    return
                }
                
            }
            complete(success)
        }
    }
    
    func addApproach(idJob: String, idUser: String, complete: @escaping (Bool, Int) -> ())
    {
        let url = "\(DAPIDefine.approach.url())/\(idJob)/\(idUser)"
        let param:[String:Any]? = nil
        
        request(urlString: url, param: param, method: .get, showLoading: false) { (success, data) in
            print(data)
            if let data_new = data as? [String: Any] {
                if data_new["message"] as! String == "Bạn đã thêm vào tiếp cận"{
                    let count_approach = data_new["count_approach"] as! Int
                    
                    complete(true, count_approach)
                    
                }else{
                    complete(false, -1)
                    return
                }
            } else {
                complete(false, -1)
            }
        }
    }
    
    func deleteListFavorite(idJob: String, idUser: String, complete: @escaping (Bool) -> ())
    {
        let url = "\(DAPIDefine.deleteFavorite.url())/\(idUser)/\(idJob)"
        let param:[String:Any]? = nil
        
        request(urlString: url, param: param, method: .get, showLoading: true) { (success, data) in
            if let data_new = data as? [String: Any] {
                if data_new["message"] as! String == "Bạn đã xóa công việc này khỏi danh sách tiếp cận"{
                    complete(true)
                    return
                }else{
                    complete(false)
                    return
                }
                
            }
            complete(success)
        }
    }
    
    func getUser(userId: String, complete: @escaping (Bool, UserModel) -> ())
    {
        let url = "\(DAPIDefine.user.url())/\(userId))"
        let param:[String:Any]? = nil
        
        request(urlString: url, param: param, method: .get, showLoading: true) { (success, data) in
            if let data_new = data as? [[String: Any]] {
                data_new.forEach({ (value) in
                    complete(true, UserModel(data: value, type: true))
                })
            return
            }
            complete(success, UserModel())
        }
    }
    
    func getCountJob(address: [AddressModel], category: [String], complete: @escaping (Bool, [CountJob]) -> ())
    {
        let url = DAPIDefine.getCountJob.url()
        
        var paramAddress = String()
        if address.count == 0 {
            paramAddress = "[]"
        } else {
            paramAddress = "["
            for addressCity in 0..<address.count {
                if addressCity == (address.count - 1) {
                    paramAddress = "\(paramAddress)\"\(address[addressCity].address!)\"]"
                } else {
                    paramAddress = "\(paramAddress)\"\(address[addressCity].address!)\","
                }
            }
        }
        
        var paramCategory = String()
        if category.count == 0 {
            paramCategory = "[]"
        } else {
            paramCategory = "["
            for addressCity in 0..<category.count {
                if addressCity == (category.count - 1) {
                    paramCategory = "\(paramCategory)\"\(category[addressCity])\"]"
                } else {
                    paramCategory = "\(paramCategory)\"\(category[addressCity])\","
                }
                
            }
            
        }
        
        let param:[String:Any]? = ["categories": paramCategory, "address": paramAddress]
        
        request(urlString: url, param: param, method: .post, showLoading: false) { (success, data) in
            if let data_new = data as? [[String: Any]] {
                var result: [CountJob] = []
                data_new.forEach({ (value) in
                    result.append(CountJob(data: value))
                })
                result.append(CountJob(job_id: -1, job_name: "Tất cả", countJob: -1))
                complete(true, result)
                return
            }
            complete(success, [])
        }
    }
    
    func getCategory(address: [AddressModel], complete: @escaping (Bool, [Category]) -> ())
    {
        let url = DAPIDefine.category.url()
        var paramAddress = String()
        if address.count == 0 {
            paramAddress = "[]"
        } else {
            paramAddress = "["
            for addressCity in 0..<address.count {
                if addressCity == (address.count - 1) {
                    paramAddress = "\(paramAddress)\"\(address[addressCity].address!)\"]"
                } else {
                    paramAddress = "\(paramAddress)\"\(address[addressCity].address!)\","
                }
                
            }
            
        }
        let param:[String:Any]? = ["address": paramAddress]
        
        request(urlString: url, param: param, method: .post, showLoading: false) { (success, data) in
            if let data_new = data as? [[String: Any]] {
                var result: [Category] = []
                data_new.forEach({ (value) in
                    result.append(Category(data: value))
                })
                complete(true, result)
                return
            }
            complete(success, [])
        }
    }
    
}
