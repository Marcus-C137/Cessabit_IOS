//
//  WrongWiFiNotifyVC.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 9/20/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import UIKit

class WrongWiFiNotifyVC: UIViewController {

    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        okBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        okBtn.setTitle("Done " + String.fontAwesomeIcon(name: .check), for: .normal)
        backBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        backBtn.setTitle( String.fontAwesomeIcon(name: .arrowLeft), for: .normal)
    }
    
    
    
    @IBAction func okPressed(_ sender: Any) {
        let SSID = WiFiService.instance.getAllWiFiNameList()
        var VC:UIViewController!
        print("Current SSID: " + SSID!)
        if SSID!.starts(with: "Cessabit"){
            VC = self.storyboard?.instantiateViewController(withIdentifier: "PickWiFiVC")
            self.present(VC!, animated: true)
        }else{
            Alert.showBasicAlert(on: self, with: "Not Connected", message: "You are not currently connected to a device. Go to Settings > Wi-Fi and connect to a network that starts with Cessabit")
        }
            }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
