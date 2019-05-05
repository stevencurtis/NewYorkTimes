//
//  SearchHeadline.swift
//  NYT
//
//  Created by Steven Curtis on 01/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation


public struct SearchHeadline : Codable {
    var main : String?
    
    private enum CodingKeys: String, CodingKey {
        case main = "main"
    }

}
