//
//  PrintService.swift
//  PrizeClaimScanner
//
//  Created by Rana Kolta on 7/18/18.
//  Copyright © 2018 Rana Kolta. All rights reserved.
//

import Foundation
import UIKit

public class PrintService: NSObject, UIPrintInteractionControllerDelegate {
    
    var scanParser: ScanParser?
    
    func printPDF(_ data: Data?) {
        if(data != nil) {
            let printController = UIPrintInteractionController.shared
            printController.delegate = self
            let printInfo = UIPrintInfo(dictionary:nil)
            printInfo.outputType = UIPrintInfo.OutputType.general
            printInfo.jobName = "Claim Form PDF"
            
            printController.printInfo = printInfo
            printController.printingItem = data
            printController.present(animated: true, completionHandler: nil)
        }
    }
    
    public func printInteractionControllerDidFinishJob(_ printInteractionController: UIPrintInteractionController) {
        //scanParser?.clearData()
    }
}
