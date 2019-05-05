//
//  DataManagerMultiton.swift
//  NYT
//
//  Created by Steven Curtis on 29/04/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation

class DataManagerSingleton {
    private static var sharedDataManager: DataManager?
    static public func createDataManager() -> DataManager {
        if sharedDataManager == nil {
            sharedDataManager = DataManager()
        }
        return sharedDataManager!
    }
}

