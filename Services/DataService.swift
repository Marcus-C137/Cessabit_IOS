//
//  DataService.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 9/13/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import Foundation
import Firebase

class DataService{
    static let instance = DataService()
    
    func newUserAdded(withFirstName firstName:String, andLastName lastName:String, andPhoneNumber phnNum:String){
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else{return}
        print("firstName \(firstName)")
        print("lastName \(lastName)")
        print("phoneNumber \(phnNum)")
        Firestore.firestore().collection("users").document(uid).setData(["firstName": firstName, "lastName": lastName, "phoneNumber": phnNum], merge: true){ err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func storePassword(Password password:String){
        UserDefaults.standard.set(password, forKey: "Password")
    }
    
    func retrievePassword() -> String{
        return UserDefaults.standard.object(forKey: "Password") as! String
    }
    
}
