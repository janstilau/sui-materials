//
//  UtilityViews.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 4/26/21.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import SwiftUI

// syntactic sure to be able to pass an optional UIImage to Image
// (normally it would only take a non-optional UIImage)

struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        // 如果, UIImage 有值, 就进行渲染, 否则就是一个 EmptyView.
        // 其实应该是返回一个大白背景 View.
        if uiImage != nil {
            Image(uiImage: uiImage!)
        }
    }
}

struct AnimatedActionButton: View {
    var title: String? = nil
    var systemImage: String? = nil
    let action: () -> Void
    
    var body: some View {
        Button {
            withAnimation {
                action()
            }
        } label: {
            if title != nil && systemImage != nil {
                Label(title!, systemImage: systemImage!)
            } else if title != nil {
                Text(title!)
            } else if systemImage != nil {
                Image(systemName: systemImage!)
            }
        }
    }
}

// simple struct to make it easier to show configurable Alerts
// just an Identifiable struct that can create an Alert on demand
// use .alert(item: $alertToShow) { theIdentifiableAlert in ... }
// where alertToShow is a Binding<IdentifiableAlert>?
// then any time you want to show an alert
// just set alertToShow = IdentifiableAlert(id: "my alert") { Alert(title: ...) }
// of course, the string identifier has to be unique for all your different kinds of alerts

struct IdentifiableAlert: Identifiable {
    var id: String
    var alert: () -> Alert
}
