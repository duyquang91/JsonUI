//
//  ResultView.swift
//  JsonUI
//
//  Created by Steve Dao on 15/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import SwiftUI
import Combine

struct ResultView: View {
    
    @Binding var showResultView: Bool
    
    @ObservedObject private var viewModel: ScannerViewModel
    @ObservedObject private var answerViewModel: SelectedAnswerViewModel
    
    private let model: QRCodeModel!
    
    init(qrCode: String, showResultView: Binding<Bool>) {
        let answerViewModel = SelectedAnswerViewModel(qrModel: try? QRCodeModel(jsonString: qrCode))
        self.model = try? QRCodeModel(jsonString: qrCode)
        self.answerViewModel = answerViewModel
        self.viewModel = ScannerViewModel(qrModel: model, answerViewModel: answerViewModel)
        self._showResultView = showResultView
    }
    
    private var navTitle: String {
        if let model = model, model.isFormatValid {
            return model.questionTitle ?? "result".locatized
        } else {
            return "error".locatized
        }
    }
    
    var body: some View {
        HUDView(isShowing: $viewModel.isLoading) {
            NavigationView {
                ScrollView(.vertical, showsIndicators: true) {
                    VStack.init(alignment: .leading, spacing: 16) {
                        if self.model == nil || !self.model.isFormatValid {
                            Text("render_failed")
                        } else {
                            Text(self.model.questionMessage)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                            
                            if self.model.imageURL != nil {
                                Image(uiImage: UIImage(data: try! Data.init(contentsOf: self.model.imageURL!))!)
                                    .resizable().scaledToFit()
                            }
                            
                            if self.model.questionType == .input {
                                TextField("answer", text: self.$viewModel.inputAnswer)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            } else {
                                SelectedAnswersView(qrModel: self.model, viewModel: self.answerViewModel)
                            }
                            
                            Button(action: {
                                self.viewModel.submitAction = Void()
                            }) {
                                Text("submit")
                                    .bold()
                                    .font(.body)
                                    .foregroundColor(Color("white_black")).padding()
                                    .frame(maxWidth:.infinity)
                                    .background(Color("black_white").opacity(self.viewModel.isReadySubmit ? 1 : 0.5))
                                    .cornerRadius(8)
                            }
                            .disabled(!self.viewModel.isReadySubmit)
                            .padding(.top, 24)
                        }
                    }
                    .padding()
                    .alert(isPresented: self.$viewModel.needShowAlert) {
                        Alert(title: Text(self.viewModel.isSubmitFailed ? "submit_failed".locatized : self.viewModel.isCorrectAnswer ? self.model.answersSuccess : self.model.answersFail!), dismissButton: Alert.Button.default(Text("dismiss")) {
                            if self.viewModel.isSubmitSuccess {
                                self.showResultView = false
                            }
                        })
                    }
                }
                .navigationBarTitle(self.navTitle)
            }
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ResultView(qrCode: QRCodeModel.mockJsonInput, showResultView: Binding<Bool>.constant(true))
                .environment(\.locale, .init(identifier: "vi"))
            
            ResultView(qrCode: QRCodeModel.mockJsonMultiChoice, showResultView: Binding<Bool>.constant(true))
                .environment(\.colorScheme, .dark)
        }
    }
}
