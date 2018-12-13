//
//  ScanData.swift
//  PrizeClaimScanner
//
//  Created by Rana Kolta on 8/8/18.
//  Copyright © 2018 Rana Kolta. All rights reserved.
//

import Foundation

struct ScanData {
    var lastName: String?   = ""
    var firstName: String?  = ""
    var suffix: String?     = ""
    var middleInitial: String? = ""
    var month: String?      = ""
    var day: String?        = ""
    var year: String?       = ""
    var address1: String?   = ""
    var address2: String?   = ""
    var city: String?       = ""
    var state: String?      = ""
    var zipcode1: String?   = ""
    var zipcode2: String?   = ""
    var country: String?    = ""
    var ticketno: String?   = ""
    var gender: Int         = 0
    var ssn1: String?       = ""
    var ssn2: String?       = ""
    var ssn3: String?       = ""
    var ph1: String?        = ""
    var ph2: String?        = ""
    var ph3: String?        = ""
    var checkDigit: String? = ""
    var prizeClaimed: String? = ""
    var email: String?      = ""
    var isScratcher: Bool   = false
    var isLotteryRetailer: Bool = false
    var isEmployedLotteryRetailer: Bool = false
    var isRelatedLotteryRetailer: Bool = false
    var noSSN: Bool = false
    var notCitizen: Bool = false
    var race: Race = Race()
    var occupation: Occupation = Occupation()
    var education: Education = Education.None
    var income: Income = Income.None
    var peopleInHousehold: String = ""
}
