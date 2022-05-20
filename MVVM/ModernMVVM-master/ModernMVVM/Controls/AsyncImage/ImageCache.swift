//
//  ImageCache.swift
//  ModernMVVM
//
//  Created by Vadym Bulavin on 2/19/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import UIKit
import SwiftUI

protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

struct TemporaryImageCache: ImageCache {
    private let cache = NSCache<NSURL, UIImage>()
    
    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set { newValue == nil ? cache.removeObject(forKey: key as NSURL) : cache.setObject(newValue!, forKey: key as NSURL) }
    }
}

/*
 A key for accessing values in the environment.
 Declaration

 protocol EnvironmentKey
 Discussion

 You can create custom environment values by extending the EnvironmentValues structure with new properties. First declare a new environment key type and specify a value for the required defaultValue property:
 private struct MyEnvironmentKey: EnvironmentKey {
     static let defaultValue: String = "Default value"
 }
 The Swift compiler automatically infers the associated Value type as the type you specify for the default value. Then use the key to define a new environment value property:
 extension EnvironmentValues {
     var myCustomValue: String {
         get { self[MyEnvironmentKey.self] }
         set { self[MyEnvironmentKey.self] = newValue }
     }
 }
 Clients of your environment value never use the key directly. Instead, they use the key path of your custom environment value property. To set the environment value for a view and all its subviews, add the environment(_:_:) view modifier to that view:
 MyView()
     .environment(\.myCustomValue, "Another string")
 As a convenience, you can also define a dedicated view modifier to apply this environment value:
 extension View {
     func myCustomValue(_ myCustomValue: String) -> some View {
         environment(\.myCustomValue, myCustomValue)
     }
 }
 This improves clarity at the call site:
 MyView()
     .myCustomValue("Another string")
 To read the value from inside MyView or one of its descendants, use the Environment property wrapper:
 struct MyView: View {
     @Environment(\.myCustomValue) var customValue: String

     var body: some View {
         Text(customValue) // Displays "Another string".
     }
 }
 */

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}
