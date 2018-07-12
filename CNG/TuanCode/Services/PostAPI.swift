//
//  PostAPI.swift
//  CNG
//
//  Created by Duy Tuan on 7/1/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView

class PostAPI: NSObject {
    static func createPost(user: UserModel, post: PostModel, param: [String: Any], image: (fileName: [String], data: [Data])) {
//
        if post.message?.trimmingCharacters(in: .whitespacesAndNewlines) == "", post.img?.fileName.count == 0 {
            let _ = MyAlert().showAlert("Bạn chưa điền nội dung!")
            return
        }
        
        guard let categoryID = post.categoryID, let jobID = post.jobID else {
            let _ = MyAlert().showAlert("Bạn chưa chọn dối tượng!")
            return
        }
        
        guard let _ = post.address, (post.address?.count)! > 0 else {
            let _ = MyAlert().showAlert("Bạn chưa chọn khu vực")
            return
        }
        
        SKActivityIndicator.show("Đang đăng bài", userInteractionStatus: false)
        
        let url = "http://150.95.109.183:3000/api/upload_job/\(user.id!)/\(categoryID)/\(jobID)"
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if image.data.count > 0 {
                for (index, data) in image.data.enumerated() {
                    multipartFormData.append(data, withName: "img", fileName: "\(image.fileName[index])", mimeType: "image/png")
                }
            } else {
                multipartFormData.append("".data(using: String.Encoding.utf8)!, withName: "img")
            }
        }, usingThreshold: UInt64.init(), to: url, method: .post) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    postJob = PostModel()
                    SKActivityIndicator.dismiss()
                    if let err = response.error {
                        print(err)
                        return
                    }
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
            }
        }
    }
    
    
}
