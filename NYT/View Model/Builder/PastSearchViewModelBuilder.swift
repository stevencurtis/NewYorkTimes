//
//  PastSearchViewModelFactory.swift
//  NYT
//
//  Created by Steven Curtis on 08/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation

public protocol PastSearchViewModelBuilderProtocol {
    func create(_ dataManager : DataManagerProtocol?) -> PastSearchViewModel
}

final public class PastSearchViewModelBuilder : PastSearchViewModelBuilderProtocol {
    public func create(_ dataManager : DataManagerProtocol? = nil) -> PastSearchViewModel {
        if let dataManager = dataManager {
            return PastSearchViewModel(dataManager: dataManager)
        }
        
        return PastSearchViewModel(dataManager: DataManager.shared)
    }
}
