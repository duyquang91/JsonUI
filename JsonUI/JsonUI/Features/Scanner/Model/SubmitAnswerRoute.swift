//
//  SubmitAnswerRoute.swift
//  JsonUI
//
//  Created by Steve Dao on 19/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import Foundation

struct SubmitAnswerRoute: APIRoutable {
    
    var url: String
    
    let questionId: String
    
    let answer: [String]
    
    let headers: [String : String]? = ["Content-Type": "application/json"]
    
    let method = HTTPMethod.post
    
    var body: [String : Any]? {
        ["questionId": questionId,
         "userEmail": userInfo?.email ?? "",
         "answer": answer]
    }
    
    @UserDefaultWrapper(key: "user_info", defaultValue: nil)
    private var userInfo: UserInfo?
}
