//
//  QRModel.swift
//  JsonUI
//
//  Created by Steve Dao on 25/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import Foundation

struct QRModel: Decodable {
    let questionId: String
    let metaData: String?
}

extension QRModel {
    static var mock: String {
        """
        {
            "metaData": "base64",
            "questionId": "16"
        }
        """
    }
}
