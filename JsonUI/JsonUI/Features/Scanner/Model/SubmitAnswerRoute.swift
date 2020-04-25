//
//  SubmitAnswerRoute.swift
//  JsonUI
//
//  Created by Steve Dao on 19/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import Foundation

struct SubmitAnswerRoute: APIRoutable {
    
    let questionModel: QuestionModel
    
    let qrModel: QRModel
    
    var url: String {
        questionModel.requestUrl!
    }
        
    let answer: [String]
    
    let headers: [String : String]? = ["Content-Type": "application/json"]
    
    let method = HTTPMethod.post
    
    var body: [String : Any]? {
        var dict: [String: Any] = ["questionId": questionModel.questionId, "userEmail": userInfo?.email ?? "", "answer": answer]
        
        if let metaData = qrModel.metaData {
            dict["metaData"] = metaData
        }
        
        if let answers = questionModel.answers, questionModel.questionType != .input {
            dict["isCorrectAnswer"] = Set(answer) == Set(answers) ? 1 : 0
        }
        
        return dict
    }
    
    private let userInfo = AppConfig.shared.userInfo
}
