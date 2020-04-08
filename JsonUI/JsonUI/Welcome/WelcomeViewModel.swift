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

class WelcomeViewModel: ObservableObject {
    
    // Inputs
    @Published var clickVoid: Void?
    
    // Output
    @Published var isUnauthorizedEnable = false
    @Published var isAuthorizedEnable = false
    
    private var disposeCancellable = Set<AnyCancellable>()
    
    init() {
        $clickVoid
            .filter { $0 != nil }
            .sink(receiveValue: { [weak self] _ in
                if AVCaptureDevice.authorizationStatus(for: .video) != .authorized {
                    AVCaptureDevice.requestAccess(for: .video) { isEnable in
                        DispatchQueue.main.async {
                            self?.isAuthorizedEnable = isEnable
                            self?.isUnauthorizedEnable = !isEnable
                        }
                    }
                }
            })
            .store(in: &disposeCancellable)
    }
}
