//
//  APIClient.swift
//  JsonUI
//
//  Created by Steve Dao on 10/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import Foundation
import Combine

class APIClient {
    
    static var `default`: APIClient {
        APIClient()
    }
    
    private let urlSession = URLSession(configuration: .default)
        
    func request(forRoute route: APIRoutable) -> URLSession.DataTaskPublisher {
        urlSession
            .dataTaskPublisher(for: route.urlRequest)
    }
    
    func request<T: Codable>(forRoute route: APIRoutable, forType: T.Type) -> AnyPublisher<T, Error> {
        urlSession
            .dataTaskPublisher(for: route.urlRequest)
            .map { $0.data }
            .handleEvents(receiveOutput: { data in
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print("Result of request: \(route.url): \(json)")
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func cancel() {
        urlSession.invalidateAndCancel()
    }
}
