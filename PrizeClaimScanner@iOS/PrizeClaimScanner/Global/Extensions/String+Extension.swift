//
//  String+Extension.swift
//  PrizeClaimScanner
//
//  Created by Rana Kolta on 7/16/18.
//  Copyright © 2018 Rana Kolta. All rights reserved.
//

import Foundation

extension String {
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        } ?? ""
    }
    
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
    
    func toNumeric() -> String
    {
        return self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }
    
    func extractString(start: Int, length: Int) -> String
    {
        if(self.count == 0)
        {
            return ""
        }
        if(self.count > start)
        {
            let remainingLength = self.count - start
            if(length == 0 || remainingLength < length) {
                let startIndex = self.index(self.startIndex, offsetBy: start)
                return String(self[startIndex..<self.endIndex])
            }
            let startIndex = self.index(self.startIndex, offsetBy: start)
            let endIndex = self.index(self.startIndex, offsetBy: (start + (length - 1)))
            return String(self[startIndex...endIndex])
        }
        return ""
    }
    
    func toPhone() -> String
    {
        var number = self.toNumeric()

        if(number.count > 3) {
            number.insert("-", at: number.index(number.startIndex, offsetBy: 3))
        }
        if(number.count > 7) {
            number.insert("-", at: number.index(number.startIndex, offsetBy: 7))
        }
        
        return number
    }
    
}
