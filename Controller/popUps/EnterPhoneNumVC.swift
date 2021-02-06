//
//  EnterPhoneNumVC.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 10/11/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import UIKit
import Firebase

class EnterPhoneNumVC: UIViewController {

    @IBOutlet weak var PhoneNumberTextView: UITextField!
    @IBOutlet weak var EnterBtn: ChkRoundedBtn!
    var uid:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        EnterBtn.setTitle(String.fontAwesomeIcon(name: .check) + " verify", for: .normal)
        uid = Auth.auth().currentUser?.uid
    }
    

    @IBAction func EnterPressed(_ sender: Any) {
        guard let phoneNum:String = PhoneNumberTextView.text else{
            print("phoneNum was null - returning")
            Alert.showBasicAlert(on: self, with: "PhoneNumber Error", message: "No phone number was entered. Press off pop-up to exit")
            return
        }
        if Int(phoneNum) != nil{
            Firestore.firestore().collection("alerts").document(uid!).updateData(["TextNums": FieldValue.arrayUnion([phoneNum])]){err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "AlertConfVC") as? AlertConfVC
            VC?.type = 1
            VC?.phoneNum = phoneNum
            self.present(VC!, animated: true)
        
        }else{
            Alert.showBasicAlert(on: self, with: "PhoneNumber Error", message: "Please Enter Phone Number With Only Numbers")
            return
        }

    }
    @IBAction func offPopUpPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
