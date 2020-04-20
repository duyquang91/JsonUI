//
//  ScannerViewModel.swift
//  JsonUI
//
//  Created by Steve Dao on 19/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import Foundation
import Combine

class ScannerViewModel: ObservableObject {
    
    // Inputs
    @Published var answers: [String] = []
    @Published var inputAnswer: String = ""
    @Published var submitAction: Void? = nil
    
    // Outputs
    @Published var isReadySubmit: Bool = false
    @Published var isLoading: Bool = false
    @Published var needShowAlert: Bool = false
    @Published var isSubmitSuccess: Bool = false
    @Published var isSubmitFailed: Bool = false
    var isCorrectAnswer: Bool {
        switch qrModel?.questionType {
        case .input:
            return true
        case .singleChoice, .multiChoice:
            return Set(answers) == Set(qrModel?.answers ?? [])
        case .none:
            return false
        }
    }
    
    // Privates
    private let qrModel: QRCodeModel?
    private var disposeStore = Set<AnyCancellable>()
    
    
    init(qrModel: QRCodeModel?, answerViewModel: SelectedAnswerViewModel) {
        self.qrModel = qrModel
        
        answerViewModel
            .$result
            .assign(to: \.answers, on: self)
            .store(in: &disposeStore)
        
        $answers
            .map { $0.count > 0 }
            .merge(with: $inputAnswer.map { !$0.isEmpty })
            .assign(to: \.isReadySubmit, on: self)
            .store(in: &disposeStore)
        
        $isSubmitSuccess
            .merge(with: $isSubmitFailed)
            .filter { $0 }
            .assign(to: \.needShowAlert, on: self)
            .store(in: &disposeStore)
        
        if let qrModel = qrModel, let url = qrModel.requestUrl {
            $submitAction
                .filter { $0 != nil }
                .map { _ in APIClient.default
                    .request(forRoute: self.getSubmitRoute(fromQrModel: qrModel, url: url))
                    .receive(on: DispatchQueue.main)
                    .handleEvents(receiveSubscription: { [weak self] _ in
                        self?.isLoading = true
                    }, receiveOutput: { [weak self] dataTask in
                        if let urlResponse = dataTask.response as? HTTPURLResponse, urlResponse.statusCode == 200 {
                            self?.isSubmitSuccess = true
                        } else {
                            self?.isSubmitFailed = true
                        }
                    }, receiveCompletion: { [weak self] completion in
                        self?.isLoading = false
                        switch completion {
                        case .finished:
                            break
                        case .failure:
                            self?.isSubmitFailed = true
                        }
                    }, receiveCancel: { [weak self] in
                        self?.isLoading = false
                    })
                    .replaceError(with: (Data(), URLResponse())) }
                .switchToLatest()
                .sink(receiveValue: { _ in })
                .store(in: &disposeStore)
        } else {
            $submitAction
                .filter { $0 != nil }
                .map { _ in true }
                .assign(to: \.isSubmitSuccess, on: self)
                .store(in: &disposeStore)
        }
        
    }
    
    private func getSubmitRoute(fromQrModel qrModel: QRCodeModel, url: String) -> APIRoutable {
        SubmitAnswerRoute(url: url, questionId: qrModel.questionId, answer: answers.isEmpty ? [inputAnswer] : answers)
    }
}
