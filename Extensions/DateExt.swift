//
//  DateExt.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 10/8/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import Foundation

extension Date {
    func isLessThan(_ date: Date) -> Bool {
        if self.timeIntervalSince(date) < date.timeIntervalSinceNow {
            return true
        }else{
            return false
        }
    }
}
