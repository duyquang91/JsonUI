//
//  SelectedAnswerViewModel.swift
//  JsonUI
//
//  Created by Steve Dao on 20/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class SelectedAnswerViewModel: ObservableObject {
    
    private let qrModel: QRCodeModel?
    
    // Inputs
    @Published var selectedAnswer: String = ""
    
    // Outputs
    @Published var result: [String] = []
    
    // Private
    private var disposeStore = Set<AnyCancellable>()
    
    init(qrModel: QRCodeModel?) {
        self.qrModel = qrModel
        
        $selectedAnswer
            .filter { !$0.isEmpty }
            .sink { [weak self] text in
                guard let self = self else { return }
                switch qrModel?.questionType {
                case .singleChoice:
                    self.result = [text]
                    
                case .multiChoice:
                    if self.result.contains(text) {
                        self.result.removeAll(where: { $0 == text })
                    } else {
                        self.result.append(text)
                    }
                    let set = Set(self.result)
                    self.result = Array(set)
                    
                default:
                    break
                }
        }
        .store(in: &disposeStore)
    }
}
