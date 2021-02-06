//
//  EditAlertContactVC.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 10/12/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import UIKit
import Firebase

class EditAlertContactVC: UIViewController {

    @IBOutlet weak var alertContact: UILabel!
    @IBOutlet weak var testBtn: ChkRoundedBtn!
    @IBOutlet weak var deleteBtn: ChkRoundedBtn!
    
    var type = 0
    var email:String?
    var phoneNum:String?
    var uid:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        testBtn.setTitle(String.fontAwesomeIcon(name: .syncAlt) + " Test", for: .normal)
        deleteBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        deleteBtn.setTitle(String.fontAwesomeIcon(name: .trash) + " Delete", for: .normal)
        
        uid = Auth.auth().currentUser?.uid
        
        if type == 0{
            alertContact.text = email!
        }else{
            alertContact.text = phoneNum!
        }
    }
    
    @IBAction func TestPressed(_ sender: Any) {

    }
    
    @IBAction func DeletePressed(_ sender: Any) {
        if type == 0 {
            Firestore.firestore().collection("alerts").document(uid!).updateData([
                "Emails" : FieldValue.arrayRemove([email!])
            ]){err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Email \(String(describing: self.email)) removed")
                }
            }
        }else{
            Firestore.firestore().collection("alerts").document(uid!).updateData([
                "TextNums" : FieldValue.arrayRemove([phoneNum!])
            ]){err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("PhoneNumber \(String(describing: self.phoneNum)) removed")
                }
            }
        }
        self.dismiss(animated: true)
    }
    @IBAction func offPopUpPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
