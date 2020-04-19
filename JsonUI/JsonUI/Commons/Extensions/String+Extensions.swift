//
//  String+Extensions.swift
//  JsonUI
//
//  Created by Steve Dao on 16/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import Foundation

extension String {
    var locatized: String {
        NSLocalizedString(self, comment: self)
    }
}

extension URLResponse {
    static var empty: URLResponse {
        URLResponse(url: URL(string: "https://google.com")!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
}
