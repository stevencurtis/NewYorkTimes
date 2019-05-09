//
//  DisplayContent.swift
//  NYT
//
//  Created by Steven Curtis on 01/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation


public struct DisplayContent {
    var title: String?
    var abstract: String?
    var thumbnailImageString: String?
    var date: String?
    var image: String?
}

extension DisplayContent: Equatable {
    public static func == (lhs: DisplayContent, rhs: DisplayContent) -> Bool {
        return lhs.title == rhs.title
        && lhs.abstract == rhs.abstract
    }
}
