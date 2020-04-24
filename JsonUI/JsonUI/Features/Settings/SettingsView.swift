//
//  SettingsView.swift
//  JsonUI
//
//  Created by Steve Dao on 12/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    private let userInfo = AppConfig.shared.userInfo
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("name")
                        Spacer()
                        Text(userInfo?.name ?? "")
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("email")
                        Spacer()
                        Text(userInfo?.email ?? "")
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("mobile")
                        Spacer()
                        Text(userInfo?.mobile ?? "")
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("address")
                        Spacer()
                        Text(userInfo?.address ?? "")
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.gray)
                    }
                }
                
                Section(footer: Text("settings_footer")) {
                    Button(action: {
                        AppConfig.shared.userInfo = nil
                    }) {
                        Text("logout")
                    }
                }.navigationBarTitle("account")
            }
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
