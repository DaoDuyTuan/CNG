//
//  SQLiteManger.swift
//  CNG
//
//  Created by Quang on 5/15/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import Foundation
import FMDB

var sharedInstance = SQLiteManger()

class SQLiteManger: NSObject {
    
    var databese:FMDatabase? = nil
    
    class func getInstance() -> SQLiteManger
    {
        sharedInstance.databese = FMDatabase(path: Util.getPath(fileName: "data.sqlite"))
        return sharedInstance
    }
    
    func getListAddress() -> [AddressModel] {
        sharedInstance.databese!.open()
        let resultSet:FMResultSet! = sharedInstance.databese!.executeQuery("SELECT * FROM ListAddress", withArgumentsIn: [])
        var itemInfo:[AddressModel] = [AddressModel]()
        if (resultSet != nil)
        {
            while resultSet.next() {
                let item = AddressModel()
                item.countJob = Int(resultSet.int(forColumn: "countJob"))
                item.address = String(resultSet.string(forColumn: "address")!)
                itemInfo.append(item)
            }
        }
        sharedInstance.databese!.close()
        return itemInfo
    }
    
    func deleteAllData() {
        sharedInstance.databese!.open()
        do {
            try sharedInstance.databese!.executeUpdate("DELETE FROM ListAddress", values: [])
        } catch {
        }
        sharedInstance.databese!.close()
    }
    
    func insertAddress(address: AddressModel){
        sharedInstance.databese!.open()
        do {
            try sharedInstance.databese!.executeUpdate("INSERT INTO ListAddress (countJob, address) VALUES (\((address.countJob!)), \"\((address.address)!)\")", values: [])
        } catch {
        }
        sharedInstance.databese!.close()
    }
    
    func checkAddress(address: AddressModel) -> Bool {
        sharedInstance.databese!.open()
        let sql = "SELECT COUNT(*)  FROM ListAddress where address = \"\((address.address)!)\""
        let resultSet:FMResultSet! = sharedInstance.databese!.executeQuery(sql, withArgumentsIn: [0])
        var totalIntermediate = 0
        if (resultSet != nil){
            while resultSet.next() {
                totalIntermediate = Int(resultSet.int(forColumn: "COUNT(*)"))
            }
        }
        sharedInstance.databese!.close()
        return totalIntermediate > 0 ? true : false
    }
    
    func getListCategory() -> [String] {
        sharedInstance.databese!.open()
        let resultSet:FMResultSet! = sharedInstance.databese!.executeQuery("SELECT * FROM ListCategory", withArgumentsIn: [])
        var itemInfo:[String] = [String]()
        if (resultSet != nil)
        {
            while resultSet.next() {
                var item = String()
                item = String(resultSet.string(forColumn: "category")!)
                itemInfo.append(item)
            }
        }
        sharedInstance.databese!.close()
        return itemInfo
    }
    
    func deleteAllDataCategory() {
        sharedInstance.databese!.open()
        do {
            try sharedInstance.databese!.executeUpdate("DELETE FROM ListCategory", values: [])
        } catch {
        }
        sharedInstance.databese!.close()
    }
    
    func insertCategory(category: String){
        sharedInstance.databese!.open()
        do {
            try sharedInstance.databese!.executeUpdate("INSERT INTO ListCategory (category) VALUES (\"\(category)\")", values: [])
        } catch {
        }
        sharedInstance.databese!.close()
    }
    
    func checkCategory(category: String) -> Bool {
        sharedInstance.databese!.open()
        let sql = "SELECT COUNT(*)  FROM ListCategory where address = \"\(category)\""
        let resultSet:FMResultSet! = sharedInstance.databese!.executeQuery(sql, withArgumentsIn: [0])
        var totalIntermediate = 0
        if (resultSet != nil){
            while resultSet.next() {
                totalIntermediate = Int(resultSet.int(forColumn: "COUNT(*)"))
            }
        }
        sharedInstance.databese!.close()
        return totalIntermediate > 0 ? true : false
    }
    
}

