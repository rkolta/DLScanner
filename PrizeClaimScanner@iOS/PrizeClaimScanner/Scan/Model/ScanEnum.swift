//
//  ScanEnum.swift
//  PrizeClaimScanner
//
//  Created by Rana Kolta on 10/1/18.
//  Copyright © 2018 Rana Kolta. All rights reserved.
//

import Foundation

enum Income: String {
    case None = "None"
    case Under25 = "Under $20K"
    case From20To35 = "$20K to $35K"
    case From35To50 = "$35K to $50K"
    case From50to75 = "$50K to $75K"
    case Over75 = "Over $75K"
}
enum Education: String {
    case None = "None"
    case NoHighSchool = "Did Not Finish High School"
    case GraduateHighSchool = "Graduated High School or GED"
    case SomeCollege = "Some College"
    case Graduate = "Graduated College"
}

extension Income: CaseIterable {}
extension Education: CaseIterable {}

