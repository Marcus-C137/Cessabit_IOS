//
//  PortAlarmCell.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 9/22/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import UIKit

protocol alarmCellNew {
    func onToggle(port: Int)
}

class PortAlarmCell: UITableViewCell {

    @IBOutlet weak var SwitchBtn: UISwitch!
    var cellDelegate: alarmCellNew?
    var port = 0
    var alarmON = false
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func AlarmsToggled(_ sender: Any) {
        cellDelegate?.onToggle(port: port)
    }
    
    func configureCell(alarm : Bool){
        SwitchBtn.setOn(alarm, animated: true)
    }
}
