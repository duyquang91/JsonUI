//
//  APIRoutable.swift
//  JsonUI
//
//  Created by Steve Dao on 10/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import Foundation

protocol APIRoutable {
    
    var url: String { get }
    
    var headers: [String: String]? { get }
    
    var method: HTTPMethod { get }
    
    var body: [String: Any]? { get }
}

extension APIRoutable {
    
    var urlRequest: URLRequest {
        
        var request = URLRequest(url: URL(string: url)!)
        
        request.httpMethod = method.rawValue
        
        if let body = body, let dataBody = try? JSONSerialization.data(withJSONObject: body) {
            request.httpBody = dataBody
        }
        
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        return request
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
