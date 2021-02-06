//
//  CodableMessage.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 9/20/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import Foundation

final class Message: Codable {
    var email:String
    var password:String
    var UID:String
    var Wifi_SSID:String
    var Wifi_password:String
    
    init(email: String, password: String, UID: String, Wifi_SSID: String, Wifi_password:String){
        self.email = email
        self.password = password
        self.UID = UID
        self.Wifi_SSID = Wifi_SSID
        self.Wifi_password = Wifi_password
    }
}
