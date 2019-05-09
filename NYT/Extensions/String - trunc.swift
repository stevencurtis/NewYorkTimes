//
//  String - trunc.swift
//  NYT
//
//  Created by Steven Curtis on 08/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation

extension String {
    /// Truncates the string to a specified number of characters with a trailing string...
    func trunc(length: Int, trailing: String = "...") -> String {
        guard length>0 else {return self}
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
}
