//
//  CreatePostContentViewController.swift
//  CNG
//
//  Created by Duy Tuan on 6/27/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit
import SDWebImage
import Photos
import BSImagePicker
import BSGridCollectionViewLayout
import Foundation
import SKActivityIndicatorView

class CreatePostContentViewController: UIViewController {
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var lblTitleOfPost: UILabel!
    @IBOutlet weak var btnPostBar: UITabBarItem!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var postTextField: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    fileprivate var imageWillShow: [UIImage]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageWillShow = [UIImage]()
        self.setUI()
        self.postTextField.addDoneButton()
        if let message = postJob.message, message.trimSpace() != "" {
            self.postTextField.textColor = UIColor.black
            self.postTextField.text = message
            SKActivityIndicator.dismiss()
        } else {
            self.postTextField.text = "Bạn đang nghĩ gì?"
        }
    }
    
    func setUI() {
        self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2
        self.profileImage.clipsToBounds = true
        
        self.profileImage.sd_setImage(with: URL(string: "https://graph.facebook.com//\(user.id!)/picture?type=large"))
        self.lblUserName.text = user.name
        self.lblTitleOfPost.text = user.name
        
        let cell = UINib(nibName: "ImageOfUserCollectionViewCell", bundle: nil)
        self.imageCollectionView.register(cell, forCellWithReuseIdentifier: "imageUser")
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chooseImageFromLibrary(_ sender: Any) {
        let vc = BSImagePickerViewController()
        
        bs_presentImagePickerController(vc, animated: true, select: { (asset: PHAsset) -> Void in
            let options = PHImageRequestOptions()
            options.version = .original
            options.isSynchronous = true
            PHImageManager.default().requestImageData(for: asset, options: options, resultHandler: { data, _, _, info in
                if let fileName = (info?["PHImageFileURLKey"] as? NSURL)?.lastPathComponent, let data = data {
                    if let count = self.imageWillShow?.count, count < 11 {
                        self.imageWillShow?.append(UIImage(data: data)!)
                        postJob.img?.fileName.append(fileName)
                        postJob.img?.data.append(data)
                    } else {
                        let _ = MyAlert().showAlert("Bạn chỉ được chọn 10 ảnh")
                    }
                }
            })
        }, deselect: { (asset: PHAsset) -> Void in
            PHImageManager.default().requestImageData(for: asset, options: nil, resultHandler: { data, _, _, info in
                
                if let fileName = (info?["PHImageFileURLKey"] as? NSURL)?.lastPathComponent{
                    print("delete: \(fileName)")
                    let index = postJob.img?.fileName.index(of: fileName)
                    if let index = index {
                        
                        postJob.img?.fileName.remove(at: index)
                        postJob.img?.data.remove(at: index)
                        self.imageWillShow?.remove(at: index)
                    }
                }
            })

        }, cancel: { (assets: [PHAsset]) -> Void in
            vc.dismiss(animated: true) {
                if let count = postJob.img?.fileName.count, count == 0 {
                    self.imageCollectionView.isHidden = true
                    self.imageCollectionView.reloadData()
                }
            }
        }, finish: { (assets: [PHAsset]) -> Void in
            vc.dismiss(animated: true) {
                if let count = postJob.img?.fileName.count, count > 0 {
                    self.imageCollectionView.isHidden = false
                    self.imageCollectionView.reloadData()
                }
            }
         }, completion: nil)
    }
    
    @IBAction func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
}

extension CreatePostContentViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textColor = UIColor.black
        if postJob.message == nil || postJob.message == "" {
            textView.text = ""
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        postJob.message = textView.text
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print(textView.text)
        postJob.message = textView.text
    }
}

extension CreatePostContentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let imageEncode: Data = UIImagePNGRepresentation(image)! as Data
            let diceRoll = Int(arc4random_uniform(UInt32(6)))
            postJob.img?.fileName.append("name\(diceRoll).jpg")
            postJob.img?.data.append(imageEncode)
            
            if let count = self.imageWillShow?.count, count < 11 {
                self.imageWillShow?.append(image)
            } else {
                let _ = MyAlert().showAlert("Bạn chỉ được chọn 10 ảnh")
            }
            
            self.imageCollectionView.isHidden = false
            self.imageCollectionView.reloadData()
            }
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CreatePostContentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageWillShow?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageUser", for: indexPath) as! ImageOfUserCollectionViewCell
        cell.imageOfUser.image = self.imageWillShow?[indexPath.row]
        cell.btnDelegate.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/4, height: collectionView.frame.height)
    }
}

extension CreatePostContentViewController: RemoveImage {
    func deleteImage(index: Int) {
        self.imageWillShow?.remove(at: index)
        postJob.img?.data.remove(at: index)
        postJob.img?.fileName.remove(at: index)
        
        if self.imageWillShow?.count == 0 {
            self.imageCollectionView.isHidden = true
        }
        self.imageCollectionView.reloadData()
    }
}

extension UIColor {
    static var myDarkTextColor = UIColor(displayP3Red: 169/255, green: 169/255, blue: 169/255, alpha: 1)
}
