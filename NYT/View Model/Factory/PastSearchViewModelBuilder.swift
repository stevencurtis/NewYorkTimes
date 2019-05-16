//
//  PastSearchViewModelFactory.swift
//  NYT
//
//  Created by Steven Curtis on 08/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation

final class PastSearchViewModelBuilder {
    static func create() -> PastSearchViewModel {
        let dataManager = DataManager.shared
        return PastSearchViewModel(dataManager: dataManager)
    }
}
