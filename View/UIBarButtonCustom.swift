//
//  UIBarButtonCustom.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 9/22/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import Foundation
import UIKit

class UIBarButtonCustom: UIBarButtonItem{
    
    UIBarButtonItem.appearance().setTitleTextAttributes(
    [
    NSAttributedStringKey.font : UIFont(name: "HelveticaNeue-Light", size: 12)!,
    NSAttributedStringKey.foregroundColor : UIColor.white,
    ], for: .normal)
}
