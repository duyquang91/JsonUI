//
//  AppConfig.swift
//  JsonUI
//
//  Created by Steve Dao on 24/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import Foundation
import UIKit

class AppConfig {
    
    static let shared = AppConfig()
    
    @UserDefaultWrapper(key: "user_info", defaultValue: nil)
    var userInfo: UserInfo? {
        didSet {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setupViews()
        }
    }
    
    private init() {}
}
