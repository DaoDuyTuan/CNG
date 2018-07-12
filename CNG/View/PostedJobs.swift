//
//  PostedJobs.swift
//  CNG
//
//  Created by Quang on 6/1/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit
import SKActivityIndicatorView

protocol CreateJob {
    func createJob()
}

class PostedJobs: UIView {

    fileprivate let viewCreateJob: UIView = {
        let view = UIView()
        view.backgroundColor = DColor.whiteColor
        return view
    }()
    
    fileprivate let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "edit")
        return view
    }()

    fileprivate let label: UILabel = {
        let label = UILabel()
        label.text = "Tạo bài viết mới để quảng cáo"
        label.textColor = DColor.blackOpacity85Percent
        label.font = DFont.fontLight(size: 12)
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    fileprivate let createPost: UILabel = {
        let label = UILabel()
        label.text = "Tạo bài viết"
        label.textColor = DColor.blackColor
        label.font = DFont.fontBold(size: 14)
        label.layer.cornerRadius = 5
        label.layer.borderWidth = 1
        label.layer.borderColor = DColor.blackColor.cgColor
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    fileprivate let labelTitle: UILabel = {
        let label = UILabel()
        label.text = "BÀI VIẾT ĐÃ ĐĂNG"
        label.textColor = DColor.blackOpacity85Percent
        label.font = DFont.fontLight(size: 12)
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    fileprivate let tableView: UITableView = {
        let table = UITableView()

        table.backgroundColor = DColor.grayColor
        return table
    }()
    
    fileprivate var listJob = [JobModel]()
    var createJob: CreateJob?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        PostedJobsTBCell.registerCellByClass(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.addSubview(viewCreateJob)
        self.addSubview(labelTitle)
        self.addSubview(tableView)
        self.viewCreateJob.addSubview(imageView)
        self.viewCreateJob.addSubview(label)
        self.viewCreateJob.addSubview(createPost)
        
        self.viewCreateJob.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview().offset(0)
            make.height.equalTo(50)
        }
        
        self.imageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.height.equalToSuperview().multipliedBy(1.0/2.0)
            make.width.equalTo(self.imageView.snp.height).multipliedBy(1.0/1.0)
            make.centerY.equalToSuperview().offset(0)
        }
        
        self.createPost.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalToSuperview().multipliedBy(1.0/2.0)
            make.width.equalTo(100)
            make.centerY.equalToSuperview().offset(0)
        }
        
        self.label.snp.makeConstraints { (make) in
            make.leading.equalTo(self.imageView.snp.trailing).offset(10)
            make.top.bottom.equalToSuperview().offset(0)
            make.trailing.equalTo(self.createPost.snp.leading).offset(-10)
        }
        
        self.labelTitle.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(0)
            make.leading.equalToSuperview().offset(15)
            make.top.equalTo(self.viewCreateJob.snp.bottom).offset(0)
            make.height.equalTo(35)
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview().offset(0)
            make.top.equalTo(self.labelTitle.snp.bottom).offset(0)
        }
     
        self.viewCreateJob.isUserInteractionEnabled = true
        self.viewCreateJob.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(createJobAction)))
        
//        APIManage.shared.getListFavorite(idUser: UserModel(data: UserModel.userCache!).id!) { (success, listJob) in
//            if success {
//
//                self.tableView.reloadData()
//            }
//        }
    }
    
    func reloadPosted() {
        SKActivityIndicator.show()
        APIManage.shared.getJobUser(idUser: UserModel(data: UserModel.userCache!).id!) { (success, listJob) in
            if success {
                self.listJob = listJob
                self.tableView.reloadData()
            }
            SKActivityIndicator.dismiss()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func createJobAction() {
        self.createJob?.createJob()
    }
}

extension PostedJobs: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listJob.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (80 + heightForLabel(text: self.listJob[indexPath.row].message!, font: DFont.fontLight(size: 16), width: UIScreen.main.bounds.size.width - 140))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PostedJobsTBCell.loadCell(self.tableView) as! PostedJobsTBCell
        cell.initData(job: self.listJob[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SKActivityIndicator.show("Đang tải ...")
        self.createJob?.createJob()
        postJob = PostModel()
        postJob.img = ([], [])
        postJob.message = self.listJob[indexPath.row].message ?? ""
    }
}

