//
//  PickWiFiVC.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 9/20/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import UIKit
import Firebase

class PickWiFiVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var connectedToLbl: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var wiFiTableView: UITableView!
    var cessabitDetectedWiFis = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        wiFiTableView.delegate = self
        wiFiTableView.dataSource = self
        setConnectionInfo()
        getCessabitWiFisSeen()
        backButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        backButton.setTitle(String.fontAwesomeIcon(name: .angleLeft), for: .normal)

    }
    
    func setConnectionInfo(){
        let SSID = WiFiService.instance.getAllWiFiNameList()
        print("Current SSID: " + SSID!)
        connectedToLbl.text = "Connected To \(SSID!)"
    }
    
    func getCessabitWiFisSeen(){
        let resourceString = "http://192.168.4.1/getKnownWiFi"
        guard let resourceURL = URL(string: resourceString) else {return}
        let task = URLSession.shared.dataTask(with: resourceURL){(data, response, err) in
            print("about to guard data")
            guard let data = data else{return}
            print("guard passed")
            do{
                self.cessabitDetectedWiFis.removeAll()
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else{return}
                print(json)
                self.cessabitDetectedWiFis = json["WiFis"] as? [String] ?? [""]
                print(self.cessabitDetectedWiFis)
                DispatchQueue.main.async { // Correct
                    self.wiFiTableView.reloadData()
                }
                
            }catch let jsonError{
                print("Error serializing json: ", jsonError)
            }
        }
        task.resume()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Table View cells \(self.cessabitDetectedWiFis.count)")
        return self.cessabitDetectedWiFis.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WiFiTVC", for: indexPath) as? WiFiTVC {
            cell.configureCell(SSID: self.cessabitDetectedWiFis[indexPath.row])
            print("configuring cell \(self.cessabitDetectedWiFis[indexPath.row])")
            return cell
        } else {
            print("returning plain tabel view")
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let WiFiNetwork = self.cessabitDetectedWiFis[indexPath.row]
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "EnterWifiPopUpVC") as? EnterWifiPopUpVC
        VC?.SSID = WiFiNetwork
        self.present(VC!, animated: true)
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        let VC = storyboard?.instantiateViewController(withIdentifier: "NavController")
        self.present(VC!, animated: true)
    }
    
}
