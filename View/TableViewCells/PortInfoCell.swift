//
//  PortInfoCell.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 9/22/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import UIKit

class PortInfoCell: UITableViewCell {

    @IBOutlet weak var AttributeLbl: UILabel!
    @IBOutlet weak var ValueLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(Attribute: String, Value: NSNumber){
        AttributeLbl.text = Attribute
        ValueLbl.text = String(describing: Value) + " F"
    }

}
