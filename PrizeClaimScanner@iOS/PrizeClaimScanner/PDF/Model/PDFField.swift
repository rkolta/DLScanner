//
//  PDFField.swift
//  PrizeClaimScanner
//
//  Created by Rana Kolta on 8/8/18.
//  Copyright © 2018 Rana Kolta. All rights reserved.
//

import Foundation

class PDFField {
    var name: String
    var tag: PDFFieldTag
    var value: String
    
    init(name: String, tag: PDFFieldTag, value: String) {
        self.name = name
        self.tag = tag
        self.value = value
    }
}
