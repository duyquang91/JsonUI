//
//  UIActivityView.swift
//  JsonUI
//
//  Created by Steve Dao on 10/4/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import Foundation
import SwiftUI

struct UIActivityView: UIViewRepresentable {

    public typealias UIViewType = UIActivityIndicatorView

    let style: UIActivityIndicatorView.Style

    public func makeUIView(context: UIViewRepresentableContext<UIActivityView>) -> UIActivityView.UIViewType {
        return UIActivityIndicatorView(style: style)
    }

    public func updateUIView(_ uiView: UIActivityView.UIViewType, context: UIViewRepresentableContext<UIActivityView>) {
        uiView.startAnimating()
    }
}
