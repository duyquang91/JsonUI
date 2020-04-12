//
//  APIClientResponseModel.swift
//  JsonUI
//
//  Created by Steve Dao on 10/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

/*

 "status": {
     "code": 1,
     "message": "email or password was invalid"
 }
 
*/

import Foundation

protocol APIClientResponse: Codable {
    var status: APIClientResponseStatus { get }
    
}

struct APIClientResponseStatus: Codable {
    let code: Int
    let message: String 
}

