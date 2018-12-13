//
//  NotificationService.swift
//  PrizeClaimScanner
//
//  Created by Rana Kolta on 8/10/18.
//  Copyright © 2018 Rana Kolta. All rights reserved.
//

import UIKit

class NotificationService {
    
    static func add(selector: Selector, listener: Any, name: String) {
        NotificationCenter.default.addObserver(listener, selector: selector, name: NSNotification.Name(name), object: nil)
    }
    
    static func post(_ name: String) {
         NotificationCenter.default.post(name: NSNotification.Name(name), object: nil)
    }
    
}
