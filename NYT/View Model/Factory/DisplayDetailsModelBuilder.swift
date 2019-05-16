//
//  DisplayDetailsModelFactory.swift
//  NYT
//
//  Created by Steven Curtis on 08/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation

final class DisplayDetailsModelBuilder {
    static func create(contents: DisplayContent) -> DisplayDetailsViewModel {
        let dataManager = DataManager.shared
        return DisplayDetailsViewModel(dataManager: dataManager, contents: contents)
    }
}
