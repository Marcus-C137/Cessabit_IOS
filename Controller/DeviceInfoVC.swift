//
//  DeviceInforVC.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 9/20/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import UIKit
import Firebase
import Charts

class DeviceInfoVC: UIViewController, UITableViewDataSource, UITableViewDelegate, alarmCellNew, ChartViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var Lbl: UILabel!
    @IBOutlet weak var barChart: BarChartView!
    
    var deviceID = ""
    var deviceListener: ListenerRegistration!
    var currentTemps = [NSNumber](repeating: 0, count: 4)
    var alarmsMonitored = [Bool](repeating: false, count: 4)
    var setTemps = [NSNumber](repeating: 0, count: 4)
    var lowAlarms = [NSNumber](repeating: 0, count: 4)
    var highAlarms = [NSNumber](repeating: 0, count: 4)
    var openedCells = [Bool](repeating: false, count: 4)
    let user = Auth.auth().currentUser
    var port1BarData = BarChartDataEntry(x:0, y:0)
    var port2BarData = BarChartDataEntry(x:1, y:0)
    var port3BarData = BarChartDataEntry(x:2, y:0)
    var port4BarData = BarChartDataEntry(x:3, y:0)
    
    var portsDataEntries = [BarChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Lbl.text = deviceID
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        setUpChart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        deviceListener = Firestore.firestore().document("users/" + user!.uid + "/devices/" + deviceID).addSnapshotListener({ (snap, err) in
            guard let doc = snap else {return}
            self.currentTemps = doc.get("currentTemps") as! [NSNumber]
            self.alarmsMonitored = doc.get("alarmsMonitored") as! [Bool]
            self.setTemps = doc.get("setTemps") as! [NSNumber]
            self.lowAlarms = doc.get("lowAlarms") as! [NSNumber]
            self.highAlarms = doc.get("highAlarms") as! [NSNumber]
            print("current Temps: " + String(describing: self.currentTemps))
            print("alarms Monitored: " + String(describing: self.alarmsMonitored))
            print("set Temps: " + String(describing: self.setTemps))
            print("low Alarms: " + String(describing: self.lowAlarms))
            print("high Alarms: " + String(describing: self.highAlarms))
            self.updateChartData()
            self.tableView.reloadData()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        deviceListener.remove()
    }
    
    @IBAction func exitPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    //get number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if openedCells[section] == true{
            return 4 + 1
        } else{
            return 1
        }
    }
    
    // configure cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PortCell") as? PortCell else {return UITableViewCell()}
            cell.configureCell(portTemp: self.currentTemps[indexPath.section], portID: (indexPath.section + 1) as NSNumber)
            return cell
        }else if indexPath.row > 0 && indexPath.row < 4 {
            // use diferent identifier here
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PortInfoCell") as? PortInfoCell else{return UITableViewCell()}
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            if indexPath.row == 1{
                cell.configureCell(Attribute: "Set Temperature", Value: setTemps[indexPath.section])
            }else if indexPath.row == 2 {
                cell.configureCell(Attribute: "High Alarm Temperature", Value: highAlarms[indexPath.section])
            }else if indexPath.row == 3{
                cell.configureCell(Attribute: "Low Alarm Temperature", Value: lowAlarms[indexPath.section])
            }
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PortAlarmCell") as? PortAlarmCell else{return UITableViewCell()}
            cell.configureCell(alarm: self.alarmsMonitored[indexPath.section])
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.alarmON = self.alarmsMonitored[indexPath.section]
            cell.port = indexPath.section
            cell.cellDelegate = self
            return cell
        }
    }
    
    //perform action when cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            if openedCells[indexPath.section] == true{
                openedCells[indexPath.section] = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }else{
                openedCells[indexPath.section] = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        }else{
            print("selected section \(indexPath.section) selected row \(indexPath.row)")
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "EnterNewTemperatureVC") as? EnterNewTemperatureVC
            VC?.deviceID = deviceID
            VC?.port = indexPath.section
            if indexPath.row == 1{
                VC?.field = "Set Temperature"
                VC?.docField = "setTemps"
                VC?.Temps = self.setTemps
            }
            if indexPath.row == 2{
                VC?.field = "High Alarm Temperature"
                VC?.docField = "highAlarms"
                VC?.Temps = self.highAlarms
            }
            if indexPath.row == 3{
                VC?.field = "Low Alarm Temperature"
                VC?.docField = "lowAlarms"
                VC?.Temps = self.lowAlarms
            }
            self.present(VC!, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    
    func onToggle(port: Int){
        print("port \(port) alarm toggled")
        self.alarmsMonitored[port] = !self.alarmsMonitored[port]
        let uid = Auth.auth().currentUser?.uid
        Firestore.firestore().collection("users/" + uid! + "/devices/").document(self.deviceID).setData(["alarmsMonitored": self.alarmsMonitored], merge: true){err in
            if let err = err{
                self.tableView.reloadData()
                print("Error updating document: \(err)")
            }else{
                self.tableView.reloadData()
            }
        }
        
    }
    
    func updateChartData(){
        for i in 0...3{
            portsDataEntries[i].y = Double(truncating: self.currentTemps[i])
        }
        let chartDataSet = BarChartDataSet(entries: portsDataEntries, label: nil)
        chartDataSet.drawValuesEnabled = false
        let chartData = BarChartData(dataSet: chartDataSet)
        chartData.barWidth = 0.5
        barChart.data = chartData
        let colors = [#colorLiteral(red: 0.3450980392, green: 0.7215686275, blue: 0.7490196078, alpha: 1)]
        chartDataSet.colors = colors
    }
    
    func setUpChart(){
        barChart.pinchZoomEnabled = false
        barChart.drawBarShadowEnabled = false
        barChart.legend.enabled = false
        barChart.drawValueAboveBarEnabled = false
        barChart.tintColor = UIColor(white: 1.0, alpha: 1.0)
        barChart.animate(xAxisDuration: 0.5)
        barChart.animate(yAxisDuration: 1)
        
        let xAxis = barChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 12)
        xAxis.granularity = 1
        xAxis.labelCount = 4
        xAxis.labelTextColor = UIColor(white: 1.0, alpha: 1.0)
        xAxis.drawGridLinesEnabled = false
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        
        
        let leftAxis = barChart.leftAxis
        leftAxis.granularity = 20
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 8
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0
        leftAxis.labelTextColor = UIColor(white: 1.0, alpha: 1.0)
        leftAxis.drawGridLinesEnabled = false
        
        let rightAxis = barChart.rightAxis
        rightAxis.drawGridLinesEnabled = false
        rightAxis.drawAxisLineEnabled = false
        rightAxis.drawLabelsEnabled = false
        
        portsDataEntries = [port1BarData, port2BarData, port3BarData, port4BarData]
        
    }
    
    

}
