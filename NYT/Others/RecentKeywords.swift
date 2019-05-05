//
//  RecentKeywords.swift
//  NYT
//
//  Created by Steven Curtis on 04/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation

protocol RecentKeywordsProtocol {
    static func returnkeywords(forKey defaultName: String) -> [String]?
    static func set(_ value: String, forKey defaultName: String)
}

final class RecentKeywords: RecentKeywordsProtocol {
    
    /// return current stored keywords
    static func returnkeywords(forKey key: String) -> [String]?
    {
        let defaults = UserDefaults.standard
        return defaults.array(forKey: key)  as? [String] ?? [String]()
    }
    
    /// changes the database synchronously
    static func set(_ value: String, forKey key: String) {
        let defaults = UserDefaults.standard
        if let words = returnkeywords(forKey: key)
        {
            let added = addWordToArray(words, value)
            if (added.set) {defaults.set(added.words, forKey: key)}
            return
        }
        defaults.set([value], forKey: key)
    }
    
    /// appends a word to the array, so long as it does not already exist and so long as is not beyond the limit
    static func addWordToArray(_  words: [String], _ value: String) -> (words:[String], set:Bool) {
        guard savedSearches > 0 else {return ([],false)}
        var set = false
        var wds = words
        while wds.count > savedSearches {
            wds.removeFirst()
        }
        if !wds.contains(value) {
            if wds.count == savedSearches && wds.count > 0  {
                wds.removeFirst()
            }
            wds.append(value)
            set = true
        }
        
        return (wds, set)
    }
    
}
