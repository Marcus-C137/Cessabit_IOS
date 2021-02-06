//
//  EmailCell.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 10/11/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import UIKit

class EmailCell: UITableViewCell {

    @IBOutlet weak var emailLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(email: String){
        emailLbl.text = email
    }

}
