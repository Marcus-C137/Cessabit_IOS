//
//  AlertPopUP.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 9/18/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import Foundation
import UIKit


struct Alert {
    static func showBasicAlert(on vc: UIViewController, with  title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async { vc.present(alert, animated: true)}
    }
}
