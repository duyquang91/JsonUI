//
//  SelectedAnswersView.swift
//  JsonUI
//
//  Created by Steve Dao on 20/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import SwiftUI

struct SelectedAnswersView: View {
    
    let qrModel: QuestionModel!
    @ObservedObject private var viewModel: SelectedAnswerViewModel
    @State private var selectedIndex = 100
    
    init(qrModel: QuestionModel, viewModel: SelectedAnswerViewModel) {
        self.qrModel = qrModel
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(qrModel.options!, id: \.self) { string in
                Button(action: {
                    self.viewModel.selectedAnswer = string
                }) {
                    HStack(alignment: .top, spacing: 8) {
                        Circle()
                            .stroke(Color("black_white"), lineWidth: 1)
                            .frame(width: 20, height: 20)
                            .overlay(Circle()
                                .fill(Color("black_white").opacity(self.viewModel.result.contains(string) ? 1 : 0))
                                .frame(width: 15, height: 15))
                        
                        Text(string)
                            .foregroundColor(Color("black_white"))
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color("black_white"), lineWidth: 1))
                }
            }
        }
    }
}

struct SelectedAnswersView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SelectedAnswersView(qrModel: try! QuestionModel.init(jsonString: QuestionModel.mockJsonInput), viewModel: SelectedAnswerViewModel())
            
            SelectedAnswersView(qrModel: try! QuestionModel.init(jsonString: QuestionModel.mockJsonInput), viewModel: SelectedAnswerViewModel())
                .environment(\.colorScheme, .dark)
        }
        
    }
}
