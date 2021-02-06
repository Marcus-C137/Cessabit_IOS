//
//  DeviceIDCellTableViewCell.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 9/20/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import UIKit

class DeviceIDCell: UITableViewCell {

 
    @IBOutlet weak var arrowLeftLbl: UILabel!
    @IBOutlet weak var deviceIDLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(deviceID: String){
        deviceIDLbl.text = deviceID
        arrowLeftLbl.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        arrowLeftLbl.text = String.fontAwesomeIcon(name: .angleRight)
    }

}
