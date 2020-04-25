//
//  QRCodeModel.swift
//  JsonUI
//
//  Created by Steve Dao on 19/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import Foundation

struct QuestionModel: Decodable {
    
    enum QuestionType: String, Codable {
        case singleChoice, multiChoice, input
    }
    
    enum CodingKeys: String, CodingKey {
        case data
        case qr_json
        case questionId
        case questionType
        case questionTitle
        case questionMessage
        case imageUrl
        case options
        case answers
        case answersSuccess
        case answersFail
        case requestUrl
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dataContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        let qrJsonContainer = try dataContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .qr_json)
        
        questionId = try qrJsonContainer.decode(String.self, forKey: .questionId)
        questionType = try qrJsonContainer.decode(QuestionType.self, forKey: .questionType)
        questionTitle = try? qrJsonContainer.decode(String.self, forKey: .questionTitle)
        questionMessage = try qrJsonContainer.decode(String.self, forKey: .questionMessage)
        imageUrl = try? qrJsonContainer.decode(String.self, forKey: .imageUrl)
        options = try? qrJsonContainer.decode([String].self, forKey: .options)
        answers = try? qrJsonContainer.decode([String].self, forKey: .answers)
        answersSuccess = try qrJsonContainer.decode(String.self, forKey: .answersSuccess)
        answersFail = try? qrJsonContainer.decode(String.self, forKey: .answersFail)
        requestUrl = try? qrJsonContainer.decode(String.self, forKey: .requestUrl)
    }
}

extension QuestionModel {
    
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
        let model = try JSONDecoder().decode(QuestionModel.self, from: jsonString.data(using: .utf8) ?? Data())
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
            "status": {
                "code": 0,
                "message": "success"
            },
            "data": {
                "qr_json": {
                    "questionId": "abc1234xyz",
                    "questionType": "singleChoice",
                    "questionTitle": "Single choice",
                    "questionMessage": "A is correct answers",
                    "options": ["A", "B", "C", "D"],
                    "answers": ["A"],
                    "imageUrl": "https://larryferlazzo.edublogs.org/files/2020/03/feedback_1583238216.png",
                    "answersSuccess": "Thank you",
                    "answersFail": "You're failed"
                }
            }
        }
        """
    }
    
    static var mockJsonMultiChoice: String {
        """
        {
            "status": {
                "code": 0,
                "message": "success"
            },
            "data": {
                "qr_json": {
                    "questionId": "abc1234xyz",
                    "questionType": "multiChoice",
                    "questionTitle": "Multiple choices",
                    "questionMessage": "A & B are correct answers",
                    "options": ["A", "B", "C", "D"],
                    "answers": ["A", "B"],
                    "imageUrl": "https://larryferlazzo.edublogs.org/files/2020/03/feedback_1583238216.png",
                    "answersSuccess": "Thank you",
                    "answersFail": "You're failed"
                }
            }
        }
        """
    }
    
    static var mockJsonInput: String {
        """
        {
            "status": {
                "code": 0,
                "message": "success"
            },
            "data": {
                "qr_json": {
                    "questionId": "abc1234xyz",
                    "questionType": "input",
                    "questionTitle": "Phản hồi",
                    "questionMessage": "Chúng tôi muốn lắng nghe ý kiến phản hồi của bạn về trung tâm để cải thiện và nâng cao chất lượng dịch vụ, bạn vui lòng dành ít phút để điền vào ô phía dưới nhé:",
                    "imageUrl": "https://larryferlazzo.edublogs.org/files/2020/03/feedback_1583238216.png",
                    "answersSuccess": "Cảm ơn bạn dành thời gian cho chúng tôi!",
                    "requestUrl": "https://stag.devmind.edu.vn/api/login"
                }
            }
        }
        """
    }
}

