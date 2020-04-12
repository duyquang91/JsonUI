//
//  LoginView.swift
//  JsonUI
//
//  Created by Steve Dao on 10/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var viewModel = LoginViewModel()
    
    var body: some View {
        
        ZStack(alignment: .center) {
            HUDView(isShowing: $viewModel.isLoading) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center, spacing: 8) {
                        
                        Image("zent_logo")
                            .resizable()
                            .frame(width: 200, height: 200)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            TextField("user_name", text: self.$viewModel.userName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            SecureField("password", text: self.$viewModel.password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Text(self.viewModel.errorText)
                                .bold()
                                .font(.footnote)
                                .foregroundColor(.red)
                            
                        }.padding(.bottom, 16)
                        
                        Button(action: {
                            self.viewModel.loginAction = Void()
                        }) {
                            Text("login")
                                .bold()
                                .font(.body)
                                .foregroundColor(Color("white_black"))
                        }
                        .disabled(!self.viewModel.isLoginButtonEnable)
                        .padding()
                        .frame(maxWidth:.infinity)
                        .background(Color("black_white"))
                        .cornerRadius(8)
                        
                        Text("login_hint")
                            .font(.footnote).opacity(0.5)
                            .padding(.top, 16)
                        
                        Spacer()
                        
                    }
                }.padding()
            }

            if viewModel.userInfo != nil {
                MainView()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView()
            LoginView()
                .environment(\.locale, .init(identifier: "vi"))
        }
    }
}
