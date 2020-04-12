//
//  UserDefaultWrapper.swift
//  JsonUI
//
//  Created by Steve Dao on 12/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefaultWrapper<T: Codable> {
    
    let key: String
    
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            guard let data = UserDefaults().data(forKey: key), let object = try? JSONDecoder().decode(T.self, from: data) else { return defaultValue }
            
            return object
        }
        
        set {
            let userDefault = UserDefaults()
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            userDefault.set(data, forKey: key)
            userDefault.synchronize()
        }
    }
}
