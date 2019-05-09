//
//  RecentKeywordsMock.swift
//  NYTTests
//
//  Created by Steven Curtis on 08/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation
@testable import NYT


class RecentKeywordsMock: RecentKeywordsProtocol {
    
    var elements = [String]()
    
    func returnkeywords(forKey defaultName: String) -> [String]? {
        return elements
    }
    
    func set(_ value: String, forKey defaultName: String) {
        elements.append(value)
    }
    
    func resetDB(_ values: [String],  forKey key: String) {
        elements.removeAll()
    }

}
