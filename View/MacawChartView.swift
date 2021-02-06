//
//  MacawChartView.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 9/21/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import Foundation
import Macaw


class MacawChartView: MacawView{
    
    static let portTempsData = createDummyData()
    static let portTempsData2 = createDummyData2()
    static let maxValue = 150
    static let lineWidth: Double = 225
    static let TemperatureData: [Double] = portTempsData.map({ $0.temp })
    static let TemperatureData2: [Double] = portTempsData2.map({ $0.temp })
    static var animations: [Animation] = []
    
    required init?(coder aDecoder: NSCoder){
        super.init(node: MacawChartView.createChart(), coder: aDecoder)
        backgroundColor = .clear
    }
    
    private static func createChart() -> Group {
        var items: [Node] = addYAxisItems() + addXAxisItems()
        items.append(createBars())
        return Group(contents: items, place: .identity)
    }
    
    private static func addYAxisItems() -> [Node]{
        
        let yTicks = 5
        let lineInterval = Int(maxValue/yTicks)
        let yAxisHeigth: Double = 150
        let lineSpacing: Double = 30
        
        var newNodes:[Node] = []
        
        for i in 1...yTicks{
            let y = yAxisHeigth - (Double(i)*lineSpacing)
            let valueText = Text(text: "\(i*lineInterval)", align: .max, baseline: .mid, place: .move(dx: -10, dy: y))
            valueText.fill = Color.white
            newNodes.append(valueText)
        }
        
        let yAxis = Line(x1: 0, y1: 0, x2: 0, y2: yAxisHeigth).stroke(fill: Color.white.with(a:0.25))
        newNodes.append(yAxis)
        
        return newNodes
    }
    
    private static func addXAxisItems() -> [Node]{
        let chartBaseY: Double = 150
        var newNodes: [Node] = []
        for i in 0...TemperatureData.count-1{
            let x = (Double(i) * 50)
            let valueText = Text(text: portTempsData[i].port, align: .max, baseline: .mid, place: .move(dx: x + 40, dy: chartBaseY + 15))
            valueText.fill = Color.white
            newNodes.append(valueText)
        }
        
        let xAxis = Line(x1: 0, y1: chartBaseY, x2: lineWidth, y2: chartBaseY).stroke(fill: Color.white.with(a: 0.25))
        newNodes.append(xAxis)
        
        return newNodes
    }
    
    private static func createBars() -> Group{
        
        let fill = LinearGradient(degree: 45, from: Color(val: 0x58B8BF), to: Color(val: 0x58B8BF).with(a:0.33))
        let items = TemperatureData.map { _ in Group()}
        animations = items.enumerated().map{(i: Int, item: Group) in
            item.contentsVar.animation(delay: Double(i) * 0.1){ t in
                let height = TemperatureData[i] * t
                let rect = Rect(x: Double(i) * 50 + 25, y: 150-height, w: 30, h: height)
                return [rect.fill(with: fill)]
            }
        }
        return items.group()
    }
    
    static func playAnimations(){
        animations.combine().play()
    }
    
    static func morphToNew(){
        let inFill = LinearGradient(degree: 45, from: Color(val: 0x58B8BF), to: Color(val: 0x58B8BF).with(a:0.33))
        var prevBars: [Shape] = []
        var nexBars: [Shape] = []
        for i in 0...3{
            let rect1 = Rect(x: Double(i) * 50 + 25, y: 0, w:30, h: TemperatureData[i])
            let rect2 = Rect(x: Double(i) * 50 + 25, y: 0, w:30, h: TemperatureData2[i])
            let prevBar = Shape(form: rect1, fill: inFill)
            let nexBar = Shape(form: rect2, fill: inFill)
            prevBars.append(prevBar)
            nexBars.append(nexBar)
        }
        let group = prevBars.group()
        let animation = group.contentsVar.animation(to: nexBars)
        animation.play()
    }
    
    private static func createDummyData() -> [portTemps]{
        let one = portTemps(port: "1", temp: 90.0)
        let two = portTemps(port: "2", temp: 0.0)
        let three = portTemps(port: "3", temp: 110.0)
        let four = portTemps(port: "4", temp: 80.0)
        return [one, two, three, four]
    }
    
    private static func createDummyData2() -> [portTemps]{
        let one = portTemps(port: "1", temp: 80.0)
        let two = portTemps(port: "2", temp: 90.0)
        let three = portTemps(port: "3", temp: 110.0)
        let four = portTemps(port: "4", temp: 30.0)
        return [one, two, three, four]
    }
}
