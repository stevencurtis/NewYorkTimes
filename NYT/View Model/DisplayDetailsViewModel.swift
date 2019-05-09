//
//  DisplayDetailsViewModel.swift
//  NYT
//
//  Created by Steven Curtis on 08/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation
import UIKit

class DisplayDetailsViewModel {
    private var dataManagerClass: DataManagerProtocol
    
    var contents : DisplayContent?

    init(dataManager: DataManagerProtocol, contents: DisplayContent? = nil) {
        self.contents = contents
        self.dataManagerClass = dataManager
        
        // if any class changes the dataManager, we want to listen to the changes and react accordingly
        dataManagerClass.articlesDidChange = { [weak self] result in
            guard let self = self else {return}
            self.contents = contents
        }
    }
}

extension DisplayDetailsViewModel {
    
    func retrieveImage(imgURL: String, completion: @escaping (Result<Data, Error>) -> Void) {
        dataManagerClass.fetchImageData(withURLString: imgURL) {
            result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async { completion(.failure(error)) }
            case .success(let data):
                DispatchQueue.main.async { completion(.success(data)) }
            }
        }
    }
}
