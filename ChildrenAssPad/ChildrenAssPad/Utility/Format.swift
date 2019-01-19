//
//  Format.swift
//  zp_chu
//
//  Created by Jaffer on 2018/7/11.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit

let digital_alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
let digital_only = "0123456789"
let digital_point = "0123456789."

class Format: NSObject {
    
    class func valid(_ string: String, withCharSet charSet: String) -> Bool {
    
        return filter(string, withCharSet: charSet) == string
    }
    
    class func filter(_ string: String, withCharSet charSet: String) -> String {
        
        let disallowedSet = CharacterSet.init(charactersIn: charSet).inverted
        
        let filteredStr = string.components(separatedBy: disallowedSet).joined(separator: "")
        
        return filteredStr
    }
    
    class func validDecimalPointFormat(forCurrentString currentString: String, replacementString replaceString: String, withLimitedDecimalLength maxDecimalLength: Int, curInputRangeLocation: Int?) -> Bool {
        
        var decimalPartLength = -1
        var decimalPointIndex = 0
        var alreadyFoundPoint = false
        
        let tempFinalString = currentString + replaceString
        
        for i in 0..<tempFinalString.count + 1 {
            let subStr = (tempFinalString as NSString).substring(to: i)
            if subStr.contains(".") {
                if !alreadyFoundPoint {
                    if i == 1 && replaceString == "." {
                        return false
                    }
                    decimalPointIndex = i
                    alreadyFoundPoint = true
                } else {
                    if replaceString == "." {
                        return false
                    }
                }
                
                decimalPartLength += 1
                if decimalPartLength > maxDecimalLength {
                    if let curInputLocation = curInputRangeLocation {
                        if curInputLocation < decimalPointIndex {
                            return true
                        }
                        return false
                    }
                }
            }
        }
        return true
    }
    
    
}


