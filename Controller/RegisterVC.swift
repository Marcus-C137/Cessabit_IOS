//
//  RegisterVC.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 9/15/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var FirstNameTxt: UITextField!
    @IBOutlet weak var LastNameTxt: UITextField!
    @IBOutlet weak var PhoneNumberTxt: UITextField!
    @IBOutlet weak var EmailTxt: UITextField!
    @IBOutlet weak var PasswordTxt: UITextField!
    @IBOutlet weak var ConfirmTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        AuthService.instance.logoutUser()
        FirstNameTxt.delegate = self
        LastNameTxt.delegate = self
        PhoneNumberTxt.delegate = self
        EmailTxt.delegate = self
        PasswordTxt.delegate = self
        ConfirmTxt.delegate = self
        FirstNameTxt.tag = 0
        LastNameTxt.tag = 1
        PhoneNumberTxt.tag = 2
        EmailTxt.tag = 3
        PasswordTxt.tag = 4
        ConfirmTxt.tag = 5
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("In text field should return")
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField{
            nextField.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    @IBAction func CreateNewAccountBtnPressed(_ sender: Any) {
        let allFieldsFilledOut = checkAllFieldsFilledOut()
        if !allFieldsFilledOut {
            Alert.showBasicAlert(on: self, with: "Form Error", message: "Please Fill Out All Fields")
            return
        }
        let passwordsMatch = checkPasswordsMatch()
        if !passwordsMatch{
            Alert.showBasicAlert(on: self, with: "Passwords Mismatch", message: "Your Password or Your Confirmed Password is Spelled Incorrectly")
            return
        }
        
        let email = EmailTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = PasswordTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let firstName = FirstNameTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = FirstNameTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let phoneNumber = PhoneNumberTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        AuthService.instance.registerUser(withEmail: email!, andPassword: password!) { (success, error) in
            if success{
                DataService.instance.newUserAdded(withFirstName: firstName!, andLastName: lastName!, andPhoneNumber: phoneNumber!)
                DataService.instance.storePassword(Password: password!)
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "EmailVerifyVC")
                self.present(VC!, animated: true, completion: {
                    
                })
            }else{
                Alert.showBasicAlert(on: self, with: "Account Error", message: error!.localizedDescription)
            }
        }
    }
    
    @IBAction func goToLoginPressed(_ sender: Any) {
        let VC = storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        self.present(VC!, animated: true) {
            
        }
    }
    
    private func checkAllFieldsFilledOut() -> Bool{
        let checkOut = (FirstNameTxt.text != nil) &&
        (LastNameTxt.text != nil) &&
        (PhoneNumberTxt.text != nil) &&
        (EmailTxt.text != nil) &&
        (PasswordTxt.text != nil) &&
        (ConfirmTxt.text != nil)
        return checkOut
    }
    
    private func checkPasswordsMatch() -> Bool{
        let password = PasswordTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let confPassword = PasswordTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return password == confPassword
    }

}
