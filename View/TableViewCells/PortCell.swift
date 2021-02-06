//
//  PortCell.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 9/22/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import UIKit

class PortCell: UITableViewCell {

    @IBOutlet weak var ArrowImageView: UIImageView!
    @IBOutlet weak var PortIDLbl: UILabel!
    @IBOutlet weak var PortTempLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(portTemp: NSNumber, portID: NSNumber){
        PortTempLbl.text = String(format: "%.2f",  portTemp as! Double) + "F"
        PortIDLbl.text = "Port " + String(describing: portID) 
    }

}
