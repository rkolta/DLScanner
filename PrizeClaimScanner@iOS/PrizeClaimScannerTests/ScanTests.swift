//
//  ScanTests.swift
//  PrizeClaimScannerTests
//
//  Created by Rana Kolta on 8/16/18.
//  Copyright © 2018 Rana Kolta. All rights reserved.
//

import XCTest
@testable import PrizeClaimScanner

class ScanTests: XCTestCase {
    
    var scanService: ScanParser!
    var mockDLScan = "\n\u{1E}\rANSI 636014040002DL00410280ZC03210042DLDCAC\nDCB01\nDCDNONE\nDBA10102022\nDCSLASTNAME\nDACFIRSTNAME\nDADMIDDLE\nDBD09072017\nDBB10051986\nDBC2\nDAYBRN\nDAU064 IN\nDAG123 FAKE ST\nDAISACRAMENTO\nDAJAR\nDAK912349999  \nDAQF6952336\nDCF08/27/2013542RB/DDFD/22\nDCGEGY\nDDEU\nDDFU\n\r"
    var mockDLUnderAge = "\n\u{1E}\rANSI 636014040002DL00410280ZC03210042DLDCAC\nDCB01\nDCDNONE\nDBA10102022\nDCSLASTNAME\nDACFIRSTNAME\nDADMIDDLE\nDBD09072017\nDBB10052018\nDBC2\nDAYBRN\nDAU064 IN\nDAG123 FAKE ST\nDAISACRAMENTO\nDAJAR\nDAK912349999  \nDAQF6952336\nDCF08/27/2013542RB/DDFD/22\nDCGEGY\nDDEU\nDDFU\n\r"
    var viewController: ViewController!
    
    override func setUp() {
        super.setUp()
        scanService = ScanParser()
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as? ViewController
        UIApplication.shared.keyWindow?.rootViewController = viewController
        _ = viewController.view
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        scanService = nil
        super.tearDown()
    }
    
    func testScanDLComplete() {
        scanService.scanDLComplete(data: mockDLScan)
        XCTAssertEqual(scanService.scanData.firstName, "FIRSTNAME")
        XCTAssertEqual(scanService.scanData.lastName, "LASTNAME")
        XCTAssertEqual(scanService.scanData.month, "10")
        XCTAssertEqual(scanService.scanData.day, "05")
        XCTAssertEqual(scanService.scanData.year, "1986")
        XCTAssertEqual(scanService.scanData.address1, "123 FAKE ST")
        XCTAssertEqual(scanService.scanData.country, "EGY")
        XCTAssertEqual(scanService.scanData.city, "SACRAMENTO")
        XCTAssertEqual(scanService.scanData.gender, 2)
        XCTAssertEqual(scanService.scanData.state, "AR")
        XCTAssertEqual(scanService.scanData.zipcode1, "91234")
        XCTAssertEqual(scanService.scanData.zipcode2, "9999")
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    //Test for underage notification
    
    func testUnderAge() {
        expectation(forNotification: NSNotification.Name(rawValue: Notifications.scanComplete.rawValue), object: nil, handler: nil)
        scanService.scanDLComplete(data: mockDLUnderAge)
        waitForExpectations(timeout: 0.5, handler: nil)
        viewController.scanParser.scanData = scanService.scanData
        viewController.checkUnderAge()
        XCTAssertTrue(viewController.presentedViewController is UIAlertController)
    }
    
}
