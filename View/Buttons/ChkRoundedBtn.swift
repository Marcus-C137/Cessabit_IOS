//
//  ChkRoundedBtn.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 9/24/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import UIKit

@IBDesignable class ChkRoundedBtn: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            layer.cornerRadius = cornerRadius

        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.clear{
        didSet{
            layer.shadowColor = shadowColor.cgColor
        }
    }

}
