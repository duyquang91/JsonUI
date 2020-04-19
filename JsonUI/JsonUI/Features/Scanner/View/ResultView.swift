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
    
    @ObservedObject private var viewModel: ScannerViewModel
    
    let qrCode: String
    private let model: QRCodeModel!
    
    init(qrCode: String) {
        self.qrCode = qrCode
        self.model = try? QRCodeModel(jsonString: qrCode)
        self.viewModel = ScannerViewModel(qrModel: model)
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
                    VStack.init(alignment: .leading, spacing: 8) {
                        if self.model == nil || !self.model.isFormatValid {
                            Text("render_failed")
                        } else {
                            Text(self.model.questionMessage)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                            if self.model.questionType == .input {
                                TextField("answer", text: self.$viewModel.inputAnswer)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            } else {
                                
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
                    .alert(isPresented: self.$viewModel.isSubmitSuccess) {
                        Alert(title: Text(self.model.answersSuccess))
                    }
                }
                .navigationBarTitle(self.navTitle)
                .alert(isPresented: self.$viewModel.isSubmitFailed) {
                    Alert(title: Text("submit_failed"))
                }
            }
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ResultView(qrCode: QRCodeModel.mockJsonInput)
                .environment(\.locale, .init(identifier: "vi"))
            
            ResultView(qrCode: QRCodeModel.mockJsonInput)
                .environment(\.colorScheme, .dark)
        }
    }
}
