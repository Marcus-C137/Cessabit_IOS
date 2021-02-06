//
//  SubscribedVC.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 10/7/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import UIKit

class SubscribedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func OkClicked(_ sender: Any) {
        let NavController = self.storyboard?.instantiateViewController(withIdentifier: "NavController")
        self.present(NavController!, animated: true)
    }
    
}
