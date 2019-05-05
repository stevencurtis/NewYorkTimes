//
//  Date - dateString.swift
//  NYT
//
//  Created by Steven Curtis on 30/04/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation

extension Date {
    var dateString: String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MMM dd, yyyy"
        return dateFormater.string(from: self)
    }
}
