//
//  Util_Library.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 21/03/2024.
//

import Foundation

class Helper {
    // This function will create random hex value
   static func generateRandomHexValue() -> String {
        let characters = "0123456789ABCDEF"
        var res = ""
        
        for _ in 0..<6 {
            if let randomChar = characters.randomElement() {
                res.append(randomChar)
            }
        }
        
//        res.insert("#", at: res.index(res.startIndex, offsetBy: 0))
        return res
    }
}
