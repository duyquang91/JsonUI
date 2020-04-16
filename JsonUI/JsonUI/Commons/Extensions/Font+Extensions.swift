//
//  Font+Extensions.swift
//  JsonUI
//
//  Created by Steve Dao on 16/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import Foundation
import SwiftUI

extension Font {
    static func from(string: String?) -> Font {
        switch string {
        case "body":
            return .body
            
        case "title":
            return .title
            
        case "headline":
            return .headline
            
        case "subheadline":
            return .subheadline
            
        case "footnote":
            return .footnote
            
        case "largeTitle":
            return .largeTitle
            
        default:
            return .body
        }
    }
}

extension Alignment {
    static func from(string: String?) -> Alignment {
        switch string {
        case "left":
            return .leading
            
        case "right":
            return .trailing
            
        default:
            return .leading
        }
    }
}
