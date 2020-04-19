//
//  SettingsView.swift
//  JsonUI
//
//  Created by Steve Dao on 12/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @UserDefaultWrapper(key: "user_info", defaultValue: nil)
    private var userInfo: UserInfo?
    
    #if DEBUG
    var userInfoText: String{
        return userInfo?.displayString ?? UserInfo(name: "SteveDao", email: "steve_dao@nedigital.se", address: "Tion-Bahru, Singapore", mobile: "+6584358144").displayString
    }
    #else
    var userInfoText: String {
        userInfo?.displayString ?? "N/A"
    }
    #endif
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    Text(userInfoText)
                    
                    Button(action: {
                        
                    }) {
                        Text("logout")
                            .bold()
                            .font(.body)
                            .foregroundColor(Color("white_black")).padding()
                            .frame(maxWidth:.infinity)
                            .background(Color("black_white"))
                            .cornerRadius(8)
                    }
                }.padding()
            }.navigationBarTitle("account")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView().environment(\.colorScheme, .dark)
            
            SettingsView().environment(\.locale, .init(identifier: "vi"))
        }
    }
}
