//
//  AlertConfVC.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 10/11/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import UIKit

class AlertConfVC: UIViewController {
    
    @IBOutlet weak var ConfLbl: UILabel!
    @IBOutlet weak var okBtn: ChkRoundedBtn!
    
    var type = 0 // 0 = email 1 = phoneNum
    var email:String?
    var phoneNum: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        okBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        okBtn.setTitle(String.fontAwesomeIcon(name: .check), for: .normal)
        if type == 0{
            ConfLbl.text = "An Email Has Been Sent To " + email! + " Have The Owner Of The Email Verify The Address"
        }else{
            ConfLbl.text = "A Text Has Been Sent To " + phoneNum! + " Have The Owner Of The Number Verify The Phone Number"
        }

    }

    @IBAction func OkPressed(_ sender: Any) {
        let VC = storyboard?.instantiateViewController(withIdentifier: "NavController")
        self.present(VC!, animated: true)
    }
    @IBAction func offPopUpPressed(_ sender: Any) {
        self.dismiss(animated:true)
    }
}
