//
//  HomeVC.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 9/15/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import UIKit
import Firebase
import StoreKit


class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var addDeviceBtn: ChkRoundedBtn!
    @IBOutlet weak var tableView: UITableView!
    
    var devicesListener: ListenerRegistration!
    var deviceIDs = [String]()
    var segueDeviceID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        addDeviceBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        addDeviceBtn.setTitle(String.fontAwesomeIcon(name: .plus), for: .normal)
        let user  = Auth.auth().currentUser
        let uid = user?.uid
        SKPaymentQueue.default().add(IAPService.instance)
        IAPService.instance.loadProducts()
        
        devicesListener = Firestore.firestore().collection("users/"+uid!+"/devices").addSnapshotListener { (snap, err) in
            if err == nil{
                if snap != nil{
                    self.deviceIDs.removeAll()
                    for doc in snap!.documents{
                        self.deviceIDs.append(doc.documentID)
                    }
                }
                print("No error")
            }else{
                print("getDevices error: \(String(describing: err?.localizedDescription))")
            }
            self.tableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        devicesListener.remove()
        deviceIDs.removeAll();
        tableView.reloadData();
    }
    
    @IBAction func setUpNewDevicePressed(_ sender: Any) {
        let SSID = WiFiService.instance.getAllWiFiNameList()
        var VC:UIViewController!
        print("Current SSID: " + SSID!)
        if SSID!.starts(with: "Cessabit"){
            VC = self.storyboard?.instantiateViewController(withIdentifier: "PickWiFiVC")
        }else{
            VC = self.storyboard?.instantiateViewController(withIdentifier: "WrongWiFiNotifyVC")
        }
        self.present(VC!, animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.deviceIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "deviceIDCell", for: indexPath) as? DeviceIDCell {
            cell.configureCell(deviceID: deviceIDs[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        segueDeviceID = deviceIDs[indexPath.row]
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "DeviceInfoVC") as? DeviceInfoVC
        VC?.deviceID = segueDeviceID
        self.present(VC!, animated: true)
        
    }
    
    
}


