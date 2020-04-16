//
//  ResultView.swift
//  JsonUI
//
//  Created by Steve Dao on 15/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import SwiftUI

struct ResultView: View {
    
    let qrCode: String
    private var jsonArray: [[String: [String: String]]] {
        guard let data = qrCode.data(using: .utf8), let dict = try? JSONSerialization.jsonObject(with: data, options: []), let dictionary = dict as? [String: Any], let formData = dictionary["formBody"] as? [[String: [String: String]]] else { return [[:]] }
        
        return formData
    }
    
    private var formTitle: String {
        guard let data = qrCode.data(using: .utf8), let dict = try? JSONSerialization.jsonObject(with: data, options: []), let dictionary = dict as? [String: Any] else { return "result" }
        return dictionary["formTitle"] as? String ?? "result"
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .center, spacing: 4) {
                    ForEach(jsonArray, id: \.self) { json in
                        self.getLabel(fromJson: json)
                    }
                }
                .padding()
            }
            .navigationBarTitle(formTitle.locatized)
        }
    }
    
    private func getLabel(fromJson json: [String: [String: String]]) -> some View {
        if let label = json["label"], let string = label["string"] {
            return Text(string)
                .font(Font.from(string: label["style"]))
                .frame(maxWidth: .infinity, alignment: Alignment.from(string: label["alignment"]))
            
        } else {
            return Text("")
                .frame(maxWidth: 0, alignment: .center)
        }
    }
    
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(qrCode: "")
    }
}
