//
//  Notification+Extensions.swift
//  JsonUI
//
//  Created by Steve Dao on 15/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import Foundation

extension Notification {
    static var codeScannerStopScanning: Notification.Name {
        Notification.Name(rawValue: "CodeScannerStopScanning")
    }
    
    static var codeScannerResumeScanning: Notification.Name {
        Notification.Name(rawValue: "CodeScannerResumeScanning")
    }
}
