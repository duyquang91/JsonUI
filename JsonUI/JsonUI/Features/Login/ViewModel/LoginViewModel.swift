//
//  LoginViewModel.swift
//  JsonUI
//
//  Created by Steve Dao on 10/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import Foundation
import Combine
import UIKit
import SwiftUI

class LoginViewModel: ObservableObject {
    
    // Inputs
    #if DEBUG
    @Published var userName: String = "wljodwaf@yomail.info"
    @Published var password: String = "Zent@2o2o"
    #else
    @Published var userName: String = ""
    @Published var password: String = ""
    #endif
    
    @Published var loginAction: Void?
    
    // Outputs
    @Published var isLoginButtonEnable = false
    @Published var errorText = ""
    @Published var isLoading = false
    @UserDefaultWrapper(key: "user_info", defaultValue: nil)
    var userInfo: UserInfo?
    
    private var disposeStore = Set<AnyCancellable>()
    
    
    init() {
        Publishers.CombineLatest($userName, $password)
            .map { !$0.0.isEmpty && !$0.1.isEmpty }
            .assign(to: \.isLoginButtonEnable, on: self)
            .store(in: &disposeStore)
        
        $loginAction
            .filter { $0 != nil }
            .filter { _ in self.isLoginButtonEnable }
            .map { _ in APIClient.default.request(forRoute: LoginRoute(email: self.userName, password: self.password), forType: LoginResponse.self)
                .receive(on: DispatchQueue.main)
                .handleEvents(receiveSubscription: { [weak self] _ in
                    self?.isLoading = true
                    }, receiveOutput: { [weak self] _ in
                        self?.isLoading = false
                    }, receiveCompletion: { [weak self] _ in
                        self?.isLoading = false
                    }, receiveCancel: { [weak self] in
                        self?.isLoading = false
                })
                .catch { Just(LoginResponse(status: APIClientResponseStatus(code: 1, message: $0.localizedDescription), data: nil))} }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] loginResponse in
                self?.userInfo = loginResponse.data?.userInfo
                self?.errorText = loginResponse.status.code == 0 ? "" : loginResponse.status.message
            })
            .store(in: &disposeStore)
    }
}
