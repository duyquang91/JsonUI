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
    
    func request(forRoute route: APIRoutable) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        return URLSession.shared
            .dataTaskPublisher(for: route.urlRequest)
            .handleEvents(receiveSubscription: { _ in
                print("*** Request URL: \(route.url)\n*** Request Method: \(route.method)\n*** Request Headers: \(String(describing: route.headers))\n*** Request Body: \(String(describing: route.body))")
            }, receiveOutput: { response in
                let json = try? JSONSerialization.jsonObject(with: response.data, options: .allowFragments)
                print("*** Request Response:\n\(String(describing: json))")
            }, receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("*** Finished")
                    
                case .failure(let error):
                    print("*** Failed with error: \(error.localizedDescription)")
                }
            }, receiveCancel: {
                print("*** Canceled")
            }).eraseToAnyPublisher()
    }
    
    func request<T: Decodable>(forRoute route: APIRoutable, forType: T.Type) -> AnyPublisher<T, Error> {
        URLSession.shared
            .dataTaskPublisher(for: route.urlRequest)
            .map { $0.data }
            .handleEvents(receiveSubscription: { _ in
                print("*** Request URL: \(route.url)\nRequest Method: \(route.method)\nRequest Headers: \(String(describing: route.headers))\nRequest Body: \(String(describing: route.body))")
            }, receiveOutput: { data in
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print("*** Request Response:\n\(String(describing: json))")
            }, receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("*** Finished")
                    
                case .failure(let error):
                    print("*** Failed with error: \(error.localizedDescription)")
                }
            }, receiveCancel: {
                print("*** Canceled")
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
    }
}
