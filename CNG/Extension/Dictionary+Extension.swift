//
//  Dictionary+Extension.swift
//  CNG
//
//  Created by Quang on 04/05/2018.
//  Copyright © 2018 Quang. All rights reserved.
//

import Foundation

// Dictionary
//------------------------------------------------------------------------------------------

//http://stackoverflow.com/questions/27723912/swift-get-request-with-parameters
extension Dictionary {
    
    /// Build string representation of HTTP parameter dictionary of keys and objects
    ///
    /// This percent escapes in compliance with RFC 3986
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped
    
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).addingPercentEncodingForURLQueryValue()!
            var percentEscapedValue = ""
            if value is String {
                percentEscapedValue = (value as! String).addingPercentEncodingForURLQueryValue()!
            }
            else if value is Int {
                percentEscapedValue = ("\(value)").addingPercentEncodingForURLQueryValue()!
            }
            
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joined(separator: "&")
    }
    
}


// NSDictionary
//------------------------------------------------------------------------------------------

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension BinaryInteger {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}


