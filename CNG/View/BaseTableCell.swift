//
//  BaseTableCell.swift
//  CNG
//
//  Created by Quang on 05/05/2018.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

class BaseTableCell: UITableViewCell {
    // MARK: init
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
    class func identifier() -> String {
        return String(describing: self.self)
    }
    class func identifier(id: String) -> String {
        return id
    }
    class func height() -> CGFloat {
        return 0
    }
    
    class func registerCellByClass(_ tableView: UITableView) {
        tableView.register(self.self, forCellReuseIdentifier: self.identifier())
    }

    class func registerCellByNib(_ tableView: UITableView) {
        let nib = UINib(nibName: self.identifier(), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: self.identifier())
    }

    class func loadCell(_ tableView: UITableView) -> BaseTableCell {
        return tableView.dequeueReusableCell(withIdentifier: self.identifier()) as! BaseTableCell
    }
    
}

