//
//  HTTPManager.swift
//  NYT
//
//  Created by Steven Curtis on 29/04/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation

public protocol HTTPManagerProtocol {
    func get(urlString: String, completionBlock: @escaping (Result<Data, Error>) -> Void)
    func get(url: URL, completionBlock: @escaping (Result<Data, Error>) -> Void)
    func returnShared () -> HTTPManagerProtocol
}

class HTTPManager {
    static let shared: HTTPManager = HTTPManager()
    
    public func returnShared () -> HTTPManagerProtocol {
        return HTTPManager.shared
    }
    
    enum HTTPError: Error {
        case invalidURL
        case noInternet
        case invalidResponse(Data?, URLResponse?)
    }
    
    public func get(urlString: String, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completionBlock(.failure(HTTPError.invalidURL))
            return
        }
        get(url: url) { (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async { completionBlock(.failure(error)) }
                
            case .success(let data):
                DispatchQueue.main.async { completionBlock(.success(data))
                }
            }
        }

    }


public func get(url: URL, completionBlock: @escaping (Result<Data, Error>) -> Void) {
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        guard error == nil else {

            completionBlock(.failure(error!))
            return
        }
        
        guard
            let responseData = data,
            let httpResponse = response as? HTTPURLResponse,
            200 ..< 300 ~= httpResponse.statusCode else {
                completionBlock(.failure(HTTPError.invalidResponse(data, response)))
                return
        }
        
        completionBlock(.success(responseData))
    }
    task.resume()
}
}




extension HTTPManager : HTTPManagerProtocol {}

