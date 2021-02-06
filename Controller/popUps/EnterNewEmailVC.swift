//
//  EnterNewEmailVC.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 10/11/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import UIKit
import Firebase

class EnterNewEmailVC: UIViewController {

    @IBOutlet weak var EmailLbl: UITextField!
    @IBOutlet weak var EnterBtn: ChkRoundedBtn!
    var uid:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        EnterBtn.setTitle(String.fontAwesomeIcon(name: .check) + " verify", for: .normal)
        uid = Auth.auth().currentUser?.uid

    }
    
    @IBAction func EnterPressed(_ sender: Any) {
        guard let email:String = EmailLbl.text else{
            print("email was null - returning")
            Alert.showBasicAlert(on: self, with: "Email Error", message: "No email address was entered. Press off pop-up to exit")
            return
        }
        if !email.contains("@"){
            Alert.showBasicAlert(on: self, with: "Email Error", message: "Please Enter a Valid Email")
            return
        }
        Firestore.firestore().collection("alerts").document(uid!).updateData(["Emails": FieldValue.arrayUnion([email])]){err in
        if let err = err {
            print("Error updating document: \(err)")
        } else {
            print("Document successfully updated")
        }
        }
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AlertConfVC") as? AlertConfVC
        VC?.type = 0
        VC?.email = email
        self.present(VC!, animated: true)
    }
    @IBAction func offPopUpPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
