//
//  ScannerView.swift
//  JsonUI
//
//  Created by Steve Dao on 12/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import SwiftUI

struct ScannerView: View {
    
    @State var isShowResult = false
    @State var qrCode = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            CodeScannerView(codeTypes: [.qr], simulatedData: "Hello world") { result in
                if let qr = try? result.get() {
                    self.qrCode = qr
                }
                self.isShowResult = true

             }
        }.sheet(isPresented: $isShowResult) {
            ResultView(qrCode: self.qrCode)
                .onAppear() {
                    NotificationCenter.default.post(Notification.init(name: Notification.codeScannerStopScanning)) }
                .onDisappear() {NotificationCenter.default.post(Notification.init(name: Notification.codeScannerResumeScanning)) }
        }
    }
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView()
    }
}
