//
//  LoginResponse.swift
//  JsonUI
//
//  Created by Steve Dao on 10/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import Foundation

struct LoginResponse: APIClientResponse {
    let status: APIClientResponseStatus
    let data: LoginData?
}

struct LoginData: Codable {
    let token: String
    let userInfo: UserInfo
    
    enum CodingKeys: String, CodingKey {
        case token
        case userInfo = "user_info"
    }
}

struct UserInfo: Codable {
    let name: String
    let email: String
    let address: String
    let mobile: String
}
