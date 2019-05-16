//
//  HomeViewModelBuilderMock.swift
//  NYTTests
//
//  Created by Steven Curtis on 16/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation
@testable import NYT

final public class HomeViewModelBuilderMock : HomeViewModelBuilderProtocol
{
    private var dataManagerClass: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol? = nil) {
        if let dm = dataManager {
            dataManagerClass = dm
        } else {
            dataManagerClass = DataManager.shared
        }
    }
    
    public func create(_ dataManager : DataManagerProtocol? = nil) -> HomeViewModelProtocol {
        if let dataManager = dataManager {
            return HomeViewModelMock(dataManager: dataManager)
        }
        
        return HomeViewModelMock(dataManager: dataManagerClass)
    }
}
