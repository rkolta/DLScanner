//
//  ScanTracker.swift
//  PrizeClaimScanner
//
//  Created by Rana Kolta on 7/16/18.
//  Copyright © 2018 Rana Kolta. All rights reserved.
//

import Foundation
// Mark: Scan Data Struct

class ScanParser: ScannerDelegate {
    
    var scanData: ScanData
    var isScanDl: Bool = false
    var isScanTicket = false
    var isFormComplete = false
    var lastScanSource: ScanSource?
    let hardCodeDigit = "35"
    
    func scanDLComplete(data: String?) {
        isScanDl = true
        lastScanSource = .driverLicense
        let dlDictionary: DriverLicenseBase
        dlDictionary = CADriverLicense()
        scanData.firstName = data?.slice(from: dlDictionary.firstName, to: "\n")
        scanData.lastName = data?.slice(from: dlDictionary.lastName, to: "\n")
        scanData.suffix = data?.slice(from: dlDictionary.suffix, to: "\n")
        if let DOB = data?.slice(from: dlDictionary.dob, to: "\n") {
            if(DOB.count == 8) {
                var start = DOB.startIndex
                var end = DOB.index(start, offsetBy: 1)
                scanData.month = String(DOB[start...end])
                
                start = DOB.index(end, offsetBy: 1)
                end = DOB.index(start, offsetBy: 1)
                scanData.day = String(DOB[start...end])
                
                start = DOB.index(end, offsetBy: 1)
                end = DOB.index(start, offsetBy: 3)
                scanData.year = String(DOB[start...end])
            }
        }
        
        if let middleInitial = data?.slice(from: dlDictionary.middleInitial, to: "\n") {
            if(middleInitial != "NONE") {
                scanData.middleInitial = String(middleInitial.prefix(1))
            }
        }
        
        scanData.address1 = data?.slice(from: dlDictionary.address1, to: "\n")
        scanData.city = data?.slice(from: dlDictionary.city, to: "\n")
        scanData.state = data?.slice(from: dlDictionary.state, to: "\n")
        let gender = data?.slice(from: dlDictionary.gender, to: "\n")
        if let genderInt = Int(gender ?? "0") {
            scanData.gender = genderInt
        }
        
        if let zipcode = data?.slice(from: dlDictionary.zipcode, to:"\n") {
            if(zipcode.count >= 5) {
                var start = zipcode.startIndex
                var end = zipcode.index(start, offsetBy: 4)
                scanData.zipcode1 = String(zipcode[start...end])
                if(zipcode.count >= 9) {
                    start = zipcode.index(end, offsetBy: 1)
                    end = zipcode.index(start, offsetBy: 3)
                    scanData.zipcode2 = (String(zipcode[start...end]) == "0000" ? "" : String(zipcode[start...end]))
                }
            }
        }
        
        if let country = data?.slice(from: dlDictionary.country, to: "\n") {
            if(country.count > 0) {
                scanData.country = country
            }
        }
        NotificationService.post(Notifications.scanComplete.rawValue)
    }
    
    func scanTicketComplete(data: String?) {
        isScanTicket = true
        lastScanSource = .ticket
        scanData.ticketno = data ?? ""
        if(scanData.ticketno!.count == 16) {
            //35 is always harcoded and it stands for CA
            scanData.ticketno!.append(hardCodeDigit)
            scanData.isScratcher = false
        } else {
            //Scratcher Game
            if(scanData.ticketno!.count >= 14) {
                //get only first 14 numbers of scratcher number, the rest are check digits
                var ticketno = scanData.ticketno!
                ticketno = String(ticketno[ticketno.startIndex...ticketno.index(ticketno.startIndex, offsetBy: 13)])
                scanData.ticketno = ticketno
            }
            scanData.isScratcher = true
        }
        //Clearing previous input User Story #195
        scanData.checkDigit = ""
        scanData.prizeClaimed = ""
        
        NotificationService.post(Notifications.scanComplete.rawValue)
    }
    
    func clearData() {
        scanData        = ScanData()
        isScanDl        = false
        isScanTicket    = false
        isFormComplete  = false
        lastScanSource  = nil
    }
    
    init() {
        scanData = ScanData()
    }
    
    //Mark: Helper Methods
    
    func isUnderAge() -> Bool {
        guard let pyear = Int(scanData.year ?? "") else { return false }
        guard let pmonth = Int(scanData.month ?? "") else { return false}
        guard let pday = Int(scanData.day ?? "") else { return false}
        let date = Date();
        let calendar = Calendar.current;
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        if(year - pyear < 18
            || (year - pyear == 18 && pmonth > month )
            || (year - pyear == 18 && pmonth == month && pday > day )) {
            return true
        }
        return false
    }
    
}
