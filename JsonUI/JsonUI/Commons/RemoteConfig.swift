//
//  RemoteConfig.swift
//  JsonUI
//
//  Created by Steve Dao on 29/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig

class AppRemoteConfig {
    
    var loginUrl: String {
        RemoteConfig.remoteConfig().configValue(forKey: "login_url").stringValue ?? "https://stag.devmind.edu.vn/api/login"
    }
    
    var getQuestionUrl: String {
        RemoteConfig.remoteConfig().configValue(forKey: "get_question_url").stringValue ?? "https://stag.devmind.edu.vn/api/questions/get"
    }
    
    static let shared = AppRemoteConfig()
    
    private init() {
        RemoteConfig.remoteConfig().setDefaults(["login_url": NSString("https://stag.devmind.edu.vn/api/login"),
                                                 "get_question_url": NSString("https://stag.devmind.edu.vn/api/questions/get")])
    }
    
    func fetchData() {
        RemoteConfig.remoteConfig().fetchAndActivate { status, error in
            if let error = error {
                print("RemoteConfig: Failed to fetch data with error: \(error.localizedDescription)")
            }
            if status == .successFetchedFromRemote {
                print("RemoteConfig: Fetched data sucessfully")
            }
        }
    }
}
