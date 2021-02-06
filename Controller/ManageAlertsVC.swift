//
//  ManageAlertsVC.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 9/17/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import UIKit
import Firebase

class ManageAlertsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var emailsTV: UITableView!
    @IBOutlet weak var phoneNumsTV: UITableView!
    @IBOutlet weak var emailTVheightConstraint: NSLayoutConstraint!
    @IBOutlet weak var phoneNumTVheightConstraint: NSLayoutConstraint!
    
    var alertContactsListener : ListenerRegistration!
    var emails = [String]()
    var textNums = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailsTV.delegate = self
        phoneNumsTV.delegate = self
        emailsTV.dataSource = self
        phoneNumsTV.dataSource = self
        emailsTV.tableFooterView = UIView()
        phoneNumsTV.tableFooterView = UIView()
        emailsTV.layer.borderColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        phoneNumsTV.layer.borderColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        emailsTV.layer.borderWidth = 2
        phoneNumsTV.layer.borderWidth = 2
        emailsTV.layer.cornerRadius = 8
        phoneNumsTV.layer.cornerRadius = 8
        setListener()
    }
    
    func setListener(){
        let uid = Auth.auth().currentUser?.uid
        alertContactsListener = Firestore.firestore().collection("alerts").document(uid!).addSnapshotListener({ (snap, err) in
            guard let doc = snap else { return }
            self.emails = doc.get("Emails") as! [String]
            self.textNums = doc.get("TextNums") as! [String]
            self.emailsTV.reloadData()
            self.phoneNumsTV.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView{
        case emailsTV:
            print("row \(indexPath.row) selected in emailsTV")
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "EditAlertContactVC") as? EditAlertContactVC
            VC?.type = 0
            VC?.email = self.emails[indexPath.row]
            self.present(VC!, animated: true)
        case phoneNumsTV:
            print("row \(indexPath.row) selected in phoneNumsTV")
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "EditAlertContactVC") as? EditAlertContactVC
            VC?.type = 1
            VC?.phoneNum = self.textNums[indexPath.row]
            self.present(VC!, animated: true)
        default:
            print("something is wrong in did select row at in tableView")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch tableView{
        case emailsTV:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmailCell") as? EmailCell else {return UITableViewCell()}
            cell.configCell(email: self.emails[indexPath.row])
            emailTVheightConstraint.constant = tableView.contentSize.height
            return cell
        case phoneNumsTV:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneNumCell") as? PhoneNumCell else {return UITableViewCell()}
            cell.configCell(phoneNumber: self.textNums[indexPath.row])
            phoneNumTVheightConstraint.constant = tableView.contentSize.height
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView{
        case emailsTV:
            return self.emails.count
        case phoneNumsTV:
            return self.textNums.count
        default:
            print("something is wrong in number of rows in section in manageAlerts")
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    @IBAction func addEmailPressed(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "EnterNewEmailVC") as? EnterNewEmailVC
        self.present(VC!, animated: true)
    }
    
    @IBAction func addPhoneNumber(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "EnterPhoneNumVC") as? EnterPhoneNumVC
        self.present(VC!, animated: true)
    }
}
