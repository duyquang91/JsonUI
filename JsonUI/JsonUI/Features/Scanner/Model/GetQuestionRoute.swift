//
//  GetQuestionRoute.swift
//  JsonUI
//
//  Created by Steve Dao on 25/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import Foundation

struct GetQuestionRoute: APIRoutable {
    
    let questionId: String
    
    var url: String {
        AppRemoteConfig.shared.getQuestionUrl + "/\(questionId)"
    }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
    
    let method = HTTPMethod.get
    
    let body: [String : Any]? = nil
}
