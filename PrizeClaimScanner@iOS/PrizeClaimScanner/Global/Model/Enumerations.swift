//
//  Structs.swift
//  PrizeClaimScanner
//
//  Created by Rana Kolta on 7/20/18.
//  Copyright © 2018 Rana Kolta. All rights reserved.
//

import Foundation

public enum ScanSource: Int {
    case driverLicense
    case ticket
}

public enum Gender: Int {
    case male = 1
    case female
}

enum PDFFieldTag {
    case firstname
    case lastname
    case suffix
    case month
    case day
    case year
    case address1
    case address2
    case city
    case country
    case email
    case state
    case zipcode1
    case zipcode2
    case ssn1
    case ssn2
    case ssn3
    case ph1
    case ph2
    case ph3
    case male
    case female
    case scratcherTicketFields
    case scratcherCheckDigit
    case gameTicketFields
    case printClear
    case question
    case field
}

enum Notifications: String {
    case toggleSideMenu = "ToggleSideMenu"
    case closeSideMenu = "CloseSideMenu"
    case helpMenu = "HelpMenu"
    case aboutMenu = "AboutMenu"
    case scanComplete = "scanComplete"
    case viewPDF = "viewPDF"
    case editForm = "editForm"
    case videoMenu = "VideoMenu"
}
