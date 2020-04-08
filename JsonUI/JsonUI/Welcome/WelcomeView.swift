//
//  WelcomeView.swift
//  JsonUI
//
//  Created by Steve Dao on 8/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    
    @ObservedObject var viewModel = WelcomeViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("welcome")
                .bold()
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("camera_permission_title").font(.title)
            
            LottieView(name: "qr_scanner")
            
            Spacer()
            
            Group {
                Button(action: {
                    self.viewModel.clickVoid = Void()
                }) {
                    Text("allow")
                    .bold()
                    .font(.body)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                }
            }
            .background(Color.black)
            .cornerRadius(8)
            
        }.padding().alert(isPresented: $viewModel.isUnauthorizedEnable) {
            Alert(title: Text("camera_permission_deny_title"), message: Text("camera_permission_deny_message"), dismissButton: .default(Text("dismiss")))
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WelcomeView()
            
            WelcomeView()
                .environment(\.locale, .init(identifier: "vi"))
                .colorScheme(.dark)
        }
        
    }
}
