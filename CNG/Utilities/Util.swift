//
//  Util.swift
//  CNG
//
//  Created by Quang on 5/15/18.
//  Copyright © 2018 Quang. All rights reserved.
//

import UIKit

class Util: NSObject {
    
    class func getPath(fileName: String) -> String {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        print(fileURL)
        return fileURL.path
    }
    
    static func attributedString(color: UIColor, string: String) -> NSAttributedString? {
        let attributes : [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.foregroundColor : color,
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue
        ]
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        return attributedString
    }
    
    class func copyFile(fileName: NSString) {
        let dbPath: String = getPath(fileName: fileName as String)
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dbPath) {
            let documentsURL = Bundle.main.resourceURL
            let fromPath = documentsURL!.appendingPathComponent(fileName as String)
            do {
                try fileManager.copyItem(atPath: fromPath.path, toPath: dbPath)
            } catch {
            }
        }
    }
}
