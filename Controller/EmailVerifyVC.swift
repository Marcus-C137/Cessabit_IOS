//
//  EmailVerifyVCViewController.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 9/13/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import UIKit
import Firebase

class EmailVerifyVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func verifiedBtnPressed(_ sender: Any) {
        Auth.auth().currentUser?.reload(completion: { (err) in
            if err == nil{
                let verified = Auth.auth().currentUser?.isEmailVerified
                print("user is email verified: \(verified!)")
                if verified! == true{
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "NavController")
                    self.present(VC!, animated: true) {
                        
                    }
                }else{
                    Alert.showBasicAlert(on: self, with: "Verification Error", message: "Verify your email before continuing")
                }
            }
        })

    }
    
    @IBAction func backToLoginBtnPressed(_ sender: Any) {
        let VC = storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        self.present(VC!, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
