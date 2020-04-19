//
//  MainView.swift
//  JsonUI
//
//  Created by Steve Dao on 12/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @State var tabSelection = 0
    
    var body: some View {
        TabView(selection: $tabSelection) {
            
            ScannerView().tabItem {
                Text("scanner")
                Image(systemName: "qrcode.viewfinder")
            }.tag(0)
            
            SettingsView().tabItem {
                Text("account")
                Image(systemName: "person.crop.circle")
            }.tag(1)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
