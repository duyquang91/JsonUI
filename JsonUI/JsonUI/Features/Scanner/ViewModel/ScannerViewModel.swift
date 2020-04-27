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
    @Published var statusString = ""
    @Published var quesionModel: QuestionModel! = nil
    @Published var isReadySubmit: Bool = false
    @Published var isLoading: Bool = false
    @Published var needShowAlert: Bool = false
    @Published var isSubmitSuccess: Bool = false
    @Published var isSubmitFailed: Bool = false
    
    var isCorrectAnswer: Bool {
        switch quesionModel?.questionType {
        case .input:
            return true
        case .singleChoice, .multiChoice:
            return Set(answers) == Set(quesionModel?.answers ?? [])
        case .none:
            return false
        }
    }
    
    // Privates
    private var qrModel: QRModel!
    private let answerViewModel: SelectedAnswerViewModel
    private var disposeStore = Set<AnyCancellable>()
    
    
    init(qrString: String, answerViewModel: SelectedAnswerViewModel) {
        self.answerViewModel = answerViewModel
        if let data = qrString.data(using: .utf8), let qrModel = try? JSONDecoder().decode(QRModel.self, from: data) {
            self.qrModel = qrModel
            self.isLoading = true
            APIClient.default
                .request(forRoute: GetQuestionRoute(questionId: qrModel.questionId), forType: QuestionModel.self)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    switch completion {
                    case .finished:
                        break
                        
                    case .failure(let error):
                        self?.statusString = error.localizedDescription
                    } }) { [weak self] question in
                        self?.quesionModel = question
                        self?.answerViewModel.questionModel = question
            }
                .store(in: &disposeStore)
        } else {
            self.statusString = "render_failed".locatized
        }

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
        
        $submitAction
            .filter { $0 != nil && self.quesionModel?.requestUrl != nil }
            .map { _ in APIClient.default
                .request(forRoute: self.getSubmitRoute(fromQrModel: self.qrModel, questionModel: self.quesionModel))
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
        
        $submitAction
            .filter { $0 != nil && self.quesionModel?.requestUrl == nil }
            .map { _ in true }
            .assign(to: \.isSubmitSuccess, on: self)
            .store(in: &disposeStore)
    }
    
    private func getSubmitRoute(fromQrModel qrModel: QRModel, questionModel: QuestionModel) -> APIRoutable {
        SubmitAnswerRoute(questionModel: quesionModel, qrModel: qrModel, answers: answers.isEmpty ? [inputAnswer] : answers)
    }
}
