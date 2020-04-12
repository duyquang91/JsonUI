//
//  ViewModel.swift
//  JsonUI
//
//  Created by Steve Dao on 8/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import Foundation
import Combine
import AVFoundation
import UIKit
import SwiftUI

class WelcomeViewModel: ObservableObject {
    
    // Inputs
    @Published var clickVoid: Void?
    
    // Output
    @Published var isUnauthorizedEnable = false
    
    var disposeStore = Set<AnyCancellable>()
    
    init() {
        $clickVoid
            .filter { $0 != nil }
            .sink(receiveValue: { [weak self] _ in
                if AVCaptureDevice.authorizationStatus(for: .video) != .authorized {
                    AVCaptureDevice.requestAccess(for: .video) { isEnable in
                        DispatchQueue.main.async {
                            self?.isUnauthorizedEnable = !isEnable
                            if isEnable {
                                guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
                                keyWindow.rootViewController = UIHostingController(rootView: LoginView())
                            }
                        }
                    }
                }
            })
            .store(in: &disposeStore)
    }
}
