//
//  WiFiService.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 9/18/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork
import Firebase

class WiFiService{
    static let instance = WiFiService()
    
    func getAllWiFiNameList() -> String? {
        var ssid = " "
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            print(interfaces)
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as! String
                    break
                }
            }
        }
        return ssid
    }
    
//    func getCessabitNetworks(onCompletion: @escaping(_ SSIDs: [String], _ Error:Bool) ->()){
//        let email = Auth.auth().currentUser?.email
//        //let password = 
//    }
    
}
