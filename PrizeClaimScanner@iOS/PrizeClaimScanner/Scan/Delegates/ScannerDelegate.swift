//
//  ScannerDelegate.swift
//  PrizeClaimScanner
//
//  Created by Rana Kolta on 7/25/18.
//  Copyright © 2018 Rana Kolta. All rights reserved.
//

protocol ScannerDelegate {
    
    func scanDLComplete(data: String?)
    func scanTicketComplete(data: String?)
    
}
