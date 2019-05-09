//
//  SearchMeta.swift
//  NYT
//
//  Created by Steven Curtis on 03/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation

public struct SearchMeta : Codable {
    var hits : Int?
    
    private enum CodingKeys: String, CodingKey {
        case hits = "hits"
    }

}
