//
//  EnterWifiPopUpVCViewController.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 9/23/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import UIKit
import Firebase

class EnterNewTemperatureVC: UIViewController {
    @IBOutlet weak var OkBtn: ChkRoundedBtn!
    @IBOutlet weak var newTempTF: UITextField!
    @IBOutlet weak var HeaderLbl: UILabel!
    
    var port = 0
    var field = " "
    var docField = " "
    var deviceID = " "
    var Temps = [NSNumber]()
    var newVal: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HeaderLbl.text = "New " + field
        OkBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        OkBtn.setTitle(String.fontAwesomeIcon(name: .check), for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(notification:Notification){
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        view.frame.origin.y = -keyboardRect.height + 100
    }
    
    @IBAction func offPopUpPress(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func OkBtnPressed(_ sender: Any) {
        guard let newTempS = newTempTF.text else {print("no value in text field returning"); return}
        guard let newTempD = Double(newTempS) else {print("could not convert to nsnumber"); return}
        let newTemp = NSNumber(value: newTempD)
        Temps[port] = newTemp
        let uid = Auth.auth().currentUser?.uid
        Firestore.firestore().collection("users").document(uid!).collection("devices").document(deviceID).setData([docField: Temps, "iChangedTemps": true], merge: true){ err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        self.dismiss(animated: true)
        
    }
 
    
}
