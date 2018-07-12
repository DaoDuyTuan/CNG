//
//  MyJobCell.swift
//  CNG
//
//  Created by Duy Tuan on 7/6/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

class MyJobCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: deinit
    deinit {
        BLogInfo("")
    }
    
    // MARK: define for cell
    class func identifier(id: String) -> String {
        return String(describing: self.self)
    }
    
    class func height() -> CGFloat {
        return 0
    }
    
    class func registerCellByClass(_ tableView: UITableView, id: String) {
        tableView.register(self.self, forCellReuseIdentifier: self.identifier(id: id))
    }
    
    class func registerCellByNib(_ tableView: UITableView, id: String) {
        let nib = UINib(nibName: self.identifier(id: id), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: self.identifier(id: id))
    }
    
    class func loadCell(_ tableView: UITableView, id: String) -> MyJobCell {
        return tableView.dequeueReusableCell(withIdentifier: self.identifier(id: id)) as! MyJobCell
    }

}
