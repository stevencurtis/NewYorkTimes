//
//  MockDataManager.swift
//  NYTTests
//
//  Created by Steven Curtis on 04/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation
import UIKit
@testable import NYT


class MockDataManager: DataManagerProtocol {
    
    var fetching = false

    func fetchImageData(withURLString urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let localImage = UIImage(named: "test.png")
        let data = localImage!.pngData()
        completion(.success(data!))
    }
    
    func fetchArticles(withAPI api: API, refresh: Bool, completion: @escaping (Result<(content: [DisplayContent], metadata: DisplayContentMetaData), Error>) -> Void) {
        if fetching {return}
        let dc = DisplayContent(title: "testTitle", abstract: "testAbstract", thumbnailImageString: "testThumbnail", date: "testDate", image: "testImg")
        let md = DisplayContentMetaData(hits: 1, page: 1)
        completion(.success(([dc],md)))
    }
    
    
    

}
