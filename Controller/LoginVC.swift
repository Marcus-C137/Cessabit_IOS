//
//  LoginVC.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 9/13/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var EmailTxtField: UITextField!
    @IBOutlet weak var PasswordTxtField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EmailTxtField.delegate = self
        PasswordTxtField.delegate = self
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)

        NotificationCenter.default.addObserver(self, selector: #selector(moveWithKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveWithKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveWithKeyboard(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func moveWithKeyboard(notification: Notification){
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification{
            view.frame.origin.y = -keyboardRect.height + 200
        }else{
            view.frame.origin.y = 0
        }
        
    }
    
    
    @IBAction func LoginPressed(_ sender: Any) {
        if EmailTxtField.text != nil && PasswordTxtField != nil{
            AuthService.instance.loginUser(withEmail: EmailTxtField.text!, andPassword: PasswordTxtField.text!) { (success, loginError) in
                if success{
                    DataService.instance.storePassword(Password: self.PasswordTxtField.text!)
                    var VC:UIViewController?
                    if Auth.auth().currentUser?.isEmailVerified == true{
                        VC = self.storyboard?.instantiateViewController(withIdentifier: "NavController")
                    }else{
                        VC = self.storyboard?.instantiateViewController(withIdentifier: "EmailVerifyVC")
                    }
                    self.present(VC!, animated: true, completion: nil)
                }else{
                    print(String(describing: loginError?.localizedDescription))
                }
            }
        }
        
    }
    
    @IBAction func RegisterPressed(_ sender: Any) {
        let RegisterVC = storyboard?.instantiateViewController(withIdentifier: "RegisterVC")
        present(RegisterVC!, animated: true, completion: nil)
    }
    

}

extension LoginVC: UITextFieldDelegate{}
