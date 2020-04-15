//
//  ResultView.swift
//  JsonUI
//
//  Created by Steve Dao on 15/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import SwiftUI

struct ResultView: View {
    
    @Binding var qrCode: String
    
    var body: some View {
        Text(qrCode)
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(qrCode: Binding<String>.constant("QR Code"))
    }
}
