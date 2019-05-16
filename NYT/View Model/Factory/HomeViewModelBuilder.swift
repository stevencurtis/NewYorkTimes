//
//  HomeViewModelFactory.swift
//  NYT
//
//  Created by Steven Curtis on 06/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation

final class HomeViewModelBuilder
{
    static func create() -> HomeViewModel {
        let dataManager = DataManager.shared
        return HomeViewModel(dataManager: dataManager)
    }
}

