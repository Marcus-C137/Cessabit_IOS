//
//  EnterWifiPopUpVCViewController.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 9/23/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import UIKit
import Firebase

class EnterWifiPopUpVC: UIViewController {
    var SSID = " "
    var Password = " "
    @IBOutlet weak var OkBtn: ChkRoundedBtn!
    @IBOutlet weak var PasswordTxtField: UITextField!
    @IBOutlet weak var SSIDLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        SSIDLbl.text = "Enter Password For " + SSID
        OkBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        OkBtn.setTitle(String.fontAwesomeIcon(name: .check), for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    func postWiFiPassword(SSID: String, WiFi_password: String){
        do{
            let UID = Auth.auth().currentUser?.uid
            let email = Auth.auth().currentUser?.email
            let password = DataService.instance.retrievePassword()
            print("Password: \(password)")
            let post = Message(email: email!, password: password, UID: UID!, Wifi_SSID: SSID, Wifi_password: WiFi_password)
            let resourceString = "http://192.168.4.1/postWiFiPassword"
            guard let resourceURL = URL(string: resourceString) else{return}
            var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = try JSONEncoder().encode(post)
            print(urlRequest.description)
            let task = URLSession.shared.dataTask(with: urlRequest){(data, response, err) in
                guard let data = data else{return}
                do{
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else{return}
                    print(json)
                }catch let jsonError{
                    print("Error serializing json: ", jsonError)
                }
            }
            task.resume()
        }catch let err{
            print(err)
        }
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
        guard let Password = PasswordTxtField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {return}
        postWiFiPassword(SSID: SSID, WiFi_password: Password)
        let VC = storyboard?.instantiateViewController(withIdentifier: "NavController")
        self.present(VC!, animated: true)
    }
    
}
