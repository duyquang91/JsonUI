//
//  QRCodeModel.swift
//  JsonUI
//
//  Created by Steve Dao on 19/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import Foundation

struct QRCodeModel: Codable {
    
    enum QuestionType: String, Codable {
        case singleChoice, multiChoice, input
    }
    
    let questionId: String
    let questionType: QuestionType
    let questionTitle: String?
    let questionMessage: String
    let options: [String]?
    let answers: [String]?
    let answersSuccess: String
    let answersFail: String?
    let requestUrl: String?
}

extension QRCodeModel {

    var isFormatValid: Bool {
        switch questionType {
        case .singleChoice:
            return options != nil && answers?.count == 1 && answersFail != nil

        case .multiChoice:
            return options != nil && answers?.count ?? 0 > 1 && answersFail != nil

        case .input:
            return options == nil && answers == nil && answersFail == nil && requestUrl != nil
        }
    }
    
    init(jsonString: String) throws {
        let model = try JSONDecoder().decode(QRCodeModel.self, from: jsonString.data(using: .utf8) ?? Data())
        questionId = model.questionId
        questionType = model.questionType
        questionTitle = model.questionTitle
        questionMessage = model.questionMessage
        options = model.options
        answers = model.answers
        answersSuccess = model.answersSuccess
        answersFail = model.answersFail
        requestUrl = model.requestUrl
    }

    static var mockJsonSingleChoice: String {
        """
        {
          "questionId": "abc1234xyz",
          "questionType": "singleChoice",
          "questionTitle": "Lịch sử",
          "questionMessage": "Đâu là tên gọi đầu tiên của nước Việt Nam?",
          "options": [
            "Xích Quỷ",
            "Văn Lang",
            "Âu Lạc",
            "Nam Việt",
            "Bộ Giao Chỉ"],
          "answers": ["Âu Lạc"],
          "answersSuccess": "Chúc mừng bạn đã trả lời đúng",
          "answersFail": "Bạn đã trả lời sai, vui lòng thử lại nhé",
          "requestUrl": "https://stag.devmind.edu.vn/api/login",
        }
        """
    }
    
    static var mockJsonMultiChoice: String {
        """
        {
          "questionId": "abc1234xyz",
          "questionType": "multiChoice",
          "questionTitle": "Lịch sử",
          "questionMessage": "1 cộng với 1 bằng bao nhiêu?",
          "options": [
            "2",
            "3",
            "Bốn",
            "Hai",
            "Mười"],
          "answers": ["2", "Hai"],
          "answersSuccess": "Chúc mừng bạn đã trả lời đúng",
          "answersFail": "Bạn đã trả lời sai, vui lòng thử lại nhé",
          "requestUrl": "https://stag.devmind.edu.vn/api/login",
        }
        """
    }
    
    static var mockJsonInput: String {
        """
        {
          "questionId": "abc1234xyz",
          "questionType": "input",
          "questionTitle": "Phản hồi",
          "questionMessage": "Chúng tôi muốn lắng nghe ý kiến phản hồi của bạn về trung tâm để cải thiện và nâng cao chất lượng dịch vụ, bạn vui lòng dành ít phút để điền vào ô phía dưới nhé:",
          "answersSuccess": "Cảm ơn bạn dành thời gian cho chúng tôi!",
          "requestUrl": "https://stag.devmind.edu.vn/api/login",
        }
        """
    }
}

