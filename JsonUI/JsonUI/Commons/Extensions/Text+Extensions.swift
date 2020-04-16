//
//  Text+Extensions.swift
//  JsonUI
//
//  Created by Steve Dao on 16/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import Foundation
import SwiftUI

extension Text {
    static func from(json: [String: String]) -> Text {
        Text(json["text"] ?? "")
    }
}
