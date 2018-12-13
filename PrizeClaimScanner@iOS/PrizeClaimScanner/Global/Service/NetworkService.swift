//
//  NetworkService.swift
//  PrizeClaimScanner
//
//  Created by Rana Kolta on 11/1/18.
//  Copyright © 2018 Rana Kolta. All rights reserved.
//

import Foundation
import SystemConfiguration

public class NetworkService {
    
    var flags:SCNetworkReachabilityFlags
    var isValidFlags:Bool
    
    init() {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        flags = SCNetworkReachabilityFlags(rawValue: 0)
        isValidFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags)
    }
    
    //MARK: Bool Functions
    
    func isConnectedToNetwork() -> Bool {
        
        if(!isValidFlags) {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        let ret = (isReachable && !needsConnection)
        return ret
    }
    
    func isWiFi() -> Bool {
        
        if(!isConnectedToNetwork()) {
            return false
        }
        if(flags.contains(.isWWAN)) {
            return false
        }
        return true
    }
    
    func isCellular() -> Bool {
        if(!isConnectedToNetwork()) {
            return false
        }
        if(!flags.contains(.isWWAN)) {
            return false
        }
        return true
    }
}
