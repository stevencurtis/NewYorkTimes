//
//  HomeViewModelFactory.swift
//  NYT
//
//  Created by Steven Curtis on 06/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation

public protocol HomeViewModelBuilderProtocol {
    func create(_ dataManager : DataManagerProtocol?) -> HomeViewModelProtocol
}

final public class HomeViewModelBuilder : HomeViewModelBuilderProtocol
{
    private var dataManagerClass: DataManagerProtocol?

    init(dataManager: DataManagerProtocol? = nil) {
        if let dm = dataManager {
            dataManagerClass = dm
        } else {
            dataManagerClass = DataManager.shared
        }
    }
    
    public func create(_ dataManager : DataManagerProtocol? = nil) -> HomeViewModelProtocol {
        if let dataManager = dataManager {
            return HomeViewModel(dataManager: dataManager)
        }

        return HomeViewModel(dataManager: DataManager.shared)
    }
}

