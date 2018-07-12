//
//  StringExtension.swift
//  CNG
//
//  Created by Quang on 04/05/2018.
//  Copyright © 2018 Quang. All rights reserved.
//

import Foundation

extension String {
    /// Percent escapes values to be added to a URL query as specified in RFC 3986
    ///
    /// This percent-escapes all characters besides the alphanumeric character set and "-", ".", "_", and "~".
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: Returns percent-escaped string.
    
    func addingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
    func trimSpace() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    
}

func readFileText(fileTextName: String) -> String {
    var text = ""
    do {
        if let file = Bundle.main.url(forResource: fileTextName, withExtension: "text") {
            let data = try Data(contentsOf: file)
            text = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        } else {
        }
    } catch {
    }
    return text
}

func convertIntToTime(time: Int) -> String{
    let minute: Int = time/60
    let second = time - minute*60
    let minuteString = minute < 10 ? "0\(minute)" : "\(minute)"
    let secondString = second < 10 ? "0\(second)" : "\(second)"
    return "\(minuteString) : \(secondString)"
}

func convertIntToTime2(time: Int) -> String{
    let minute: Int = time/60
    let second = time - minute*60
    let minuteString = minute < 10 ? "0\(minute)" : "\(minute)"
    let secondString = second < 10 ? "0\(second)" : "\(second)"
    return "\(minuteString)p : \(secondString)s"
}

