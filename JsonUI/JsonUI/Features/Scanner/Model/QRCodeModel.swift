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
    let imageUrl: String?
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
            if let options = options, let answers = answers, answersFail != nil {
                return options.count > 0 && answers.count == 1
            } else {
                return false
            }
            
        case .multiChoice:
            return options != nil && answers?.count ?? 0 > 1 && answersFail != nil
            
        case .input:
            return options == nil && answers == nil && answersFail == nil && requestUrl != nil
        }
    }
    
    var imageURL: URL? {
        guard let imageUrlString = imageUrl, let url = URL(string: imageUrlString) else { return nil }
        return url
    }
    
    init(jsonString: String) throws {
        let model = try JSONDecoder().decode(QRCodeModel.self, from: jsonString.data(using: .utf8) ?? Data())
        questionId = model.questionId
        questionType = model.questionType
        questionTitle = model.questionTitle
        questionMessage = model.questionMessage
        imageUrl = model.imageUrl
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
        "questionMessage": "Nhà đầu tư nào đã bỏ công sức, mồ hôi nước mắt nhất vào trung tâm Zent?",
        "options": [
        "Thương",
        "Minh",
        "Hiệp"],
        "answers": ["Thương"],
        "answersSuccess": "Không nó thì là ai nữa hả bạn?",
        "answersFail": "Bạn đã trả lời sai, bạn đéo biết con cặc gì về chúng tôi!",
        "requestUrl": "https://stag.devmind.edu.vn/api/login"
        }
        """
    }
    
    static var mockJsonMultiChoice: String {
        """
        {
        "questionId": "abc1234xyz",
        "questionType": "multiChoice",
        "questionTitle": "Tình anh em",
        "questionMessage": "Đâu là những người anh em chí cốt, vào sinh ra tử cùng với Vũ Văn Thương gầy dựng nên trung tâm Zent?",
        "options": [
        "Hiệp",
        "Quang",
        "Quỳnh",
        "Minh",
        "Bách"],
        "answers": ["Hiệp", "Minh"],
        "answersSuccess": "Bạn hiểu Thương vl!",
        "answersFail": "Bạn đéo hiểu con cặc gì về Thương cả, chán vkl!",
        "requestUrl": "https://stag.devmind.edu.vn/api/login"
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
        "imageUrl": "https://larryferlazzo.edublogs.org/files/2020/03/feedback_1583238216.png",
        "answersSuccess": "Cảm ơn bạn dành thời gian cho chúng tôi!",
        "requestUrl": "https://stag.devmind.edu.vn/api/login"
        }
        """
    }
}

