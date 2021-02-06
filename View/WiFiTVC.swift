//
//  WiFiTVC.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 9/20/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import UIKit

class WiFiTVC: UITableViewCell {

    @IBOutlet weak var WifiNameLbl: UILabel!
    @IBOutlet weak var WifiSSIDlbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(SSID: String){
        WifiNameLbl.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        WifiNameLbl.text = String.fontAwesomeIcon(name: .wifi)
        WifiSSIDlbl.text = SSID
    }


}
