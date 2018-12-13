//
//  DriverLicenseBase.swift
//  PrizeClaimScanner
//
//  Created by Rana Kolta on 9/20/18.
//  Copyright © 2018 Rana Kolta. All rights reserved.
//

import Foundation

protocol DriverLicenseBase {
    var firstName: String {get set}
    var lastName: String {get set}
    var middleInitial: String {get set}
    var suffix: String {get set}
    var dob: String {get set}
    var address1: String {get set}
    var city: String {get set}
    var state: String {get set}
    var gender: String {get set}
    var zipcode: String {get set}
    var country: String {get set}
}
