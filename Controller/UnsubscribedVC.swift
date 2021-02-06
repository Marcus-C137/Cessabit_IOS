//
//  UnsubscribedVC.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 10/8/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import UIKit

class UnsubscribedVC: UIViewController {

    @IBOutlet weak var Lbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        backBtn.setTitle(String.fontAwesomeIcon(name: .angleLeft), for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(userSubsribed), name: NSNotification.Name("SubChange"), object: nil)
    }
    
    @objc func userSubsribed(_ notification: Notification){
        guard let status = notification.object as? Bool else { return }
        DispatchQueue.main.async {
            if status == true {
                let SubscribedVC = self.storyboard?.instantiateViewController(withIdentifier: "SubscribedVC")
                self.present(SubscribedVC!, animated: true)
            }
        }

    }
    
    @IBAction func ButtonPressed(_ sender: Any) {
        print("Button Pressed")
        IAPService.instance.attemptPurchaseofSubscription()
    }

    @IBAction func returnPressed(_ sender: Any) {
        let navController = self.storyboard?.instantiateViewController(withIdentifier: "NavController")
        self.present(navController!, animated: true)
    }
}
