//
//  EnterWifiView.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 9/23/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import UIKit

@IBDesignable class EnterWifiView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }

}
