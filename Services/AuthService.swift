//
//  AuthService.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 9/13/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import Foundation
import Firebase

class AuthService{
    static let instance = AuthService()
    
    func registerUser(withEmail email:String, andPassword password: String, userCreationComplete: @escaping(_ status:Bool,_ error: Error?) ->()){
        Auth.auth().createUser(withEmail: email, password: password){ authResult, error in
            guard let user = authResult?.user else{
                userCreationComplete(false, error)
                print("User Creation Error")
                return
            }
            user.sendEmailVerification(completion: { (err) in
                if err != nil{
                    print("email verfication error: \(err!.localizedDescription)")
                }else{
                    print("email verification sent successfully")
                }
            })
            userCreationComplete(true, nil)
        }
        
    }
    
    func loginUser(withEmail email:String, andPassword password: String, loginComplete: @escaping(_ status:Bool,_ error: Error?) ->()){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil{
                loginComplete(false, error)
                return
            }
            loginComplete(true, nil)
        }
    }
    
    func logoutUser(){
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func subscribeUser(){
        let uid = Auth.auth().currentUser?.uid
        Firestore.firestore().collection("payments").document(uid!).setData(["Subscription_Active": true], merge: true){ err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    

}
