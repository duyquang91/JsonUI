//
//  MainView.swift
//  JsonUI
//
//  Created by Steve Dao on 12/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @State var tabSelection = 1
    
    var body: some View {
        TabView(selection: $tabSelection) {
            HistoryView().tabItem {
                Text("history")
            }.tag(0)
            
            ScannerView().tabItem {
                Text("scanner")
            }.tag(1)
            
            SettingsView().tabItem {
                Text("settings")
            }.tag(2)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
