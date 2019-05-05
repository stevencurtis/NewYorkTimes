//
//  SearchDoc.swift
//  testjson
//
//  Created by Steven Curtis on 01/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation

public struct SearchDoc : Codable {
    var docs: [SearchArticle]?
    var meta: SearchMeta?
    
    private enum ContentResponse: String, CodingKey {
        case docs = "docs"
        case meta = "meta"

    }
}
