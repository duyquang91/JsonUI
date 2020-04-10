//
//  HUDView.swift
//  JsonUI
//
//  Created by Steve Dao on 10/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import Foundation
import SwiftUI

struct HUDView<Content>: View where Content: View {
    private var isShowing: Binding<Bool>
    private var content: () -> Content
    
    public init(isShowing: Binding<Bool>, content: @escaping () -> Content) {
        self.isShowing = isShowing
        self.content = content
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                if (!self.isShowing.wrappedValue) {
                    self.content()
                } else {
                    
                    self.content()
                        .disabled(true)
                        .blur(radius: 10, opaque: false)
                    
                    VStack {
                        UIActivityView(style: .large)
                        Text("loading")
                    }
                    .frame(width: 120, height: 120, alignment: .center)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(16)
                    .shadow(radius: 50)
                }
            }
        }
    }
}

struct HUDView_Previews: PreviewProvider {
    static var previews: some View {
        HUDView(isShowing: Binding<Bool>.constant(true)) {
            EmptyView()
        }
    }
}
