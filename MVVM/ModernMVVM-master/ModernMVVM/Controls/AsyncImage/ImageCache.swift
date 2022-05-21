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
        set {
            if let newImg = newValue {
                cache.setObject(newImg, forKey: key as NSURL)
            } else {
                cache.removeObject(forKey: key as NSURL)
            }
        }
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

// 自定义, EnvironmentValues 的操作.
/*
 EnvironmentValues 是真正的, 进行存储的容器所在.
 它使用 ImageCacheKey 来进行 get, set
 
 EnvironmentKey 是特殊的 key 值, 提供默认值, 最重要的是, 提供了类型绑定的机制.
 
 
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


/*
 
 /// A property wrapper that reads a value from a view's environment.
 ///
 /// Use the `Environment` property wrapper to read a value
 /// stored in a view's environment. Indicate the value to read using an
 /// ``EnvironmentValues`` key path in the property declaration. For example, you
 /// can create a property that reads the color scheme of the current
 /// view using the key path of the ``EnvironmentValues/colorScheme``
 /// property:
 ///
 ///     @Environment(\.colorScheme) var colorScheme: ColorScheme
 ///
 /// You can condition a view's content on the associated value, which
 /// you read from the declared property's ``wrappedValue``. As with any property
 /// wrapper, you access the wrapped value by directly referring to the property:
 ///
 ///     if colorScheme == .dark { // Checks the wrapped value.
 ///         DarkContent()
 ///     } else {
 ///         LightContent()
 ///     }
 ///
 /// If the value changes, SwiftUI updates any parts of your view that depend on
 /// the value. For example, that might happen in the above example if the user
 /// changes the Appearance settings.
 ///
 /// You can use this property wrapper to read --- but not set --- an environment
 /// value. SwiftUI updates some environment values automatically based on system
 /// settings and provides reasonable defaults for others. You can override some
 /// of these, as well as set custom environment values that you define,
 /// using the ``View/environment(_:_:)`` view modifier.
 ///
 /// For the complete list of environment values provided by SwiftUI, see the
 /// properties of the ``EnvironmentValues`` structure. For information about
 /// creating custom environment values, see the ``EnvironmentKey`` protocol.
 @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
 @frozen @propertyWrapper public struct Environment<Value> : DynamicProperty {

     /// Creates an environment property to read the specified key path.
     ///
     /// Don’t call this initializer directly. Instead, declare a property
     /// with the ``Environment`` property wrapper, and provide the key path of
     /// the environment value that the property should reflect:
     ///
     ///     struct MyView: View {
     ///         @Environment(\.colorScheme) var colorScheme: ColorScheme
     ///
     ///         // ...
     ///     }
     ///
     /// SwiftUI automatically updates any parts of `MyView` that depend on
     /// the property when the associated environment value changes.
     /// You can't modify the environment value using a property like this.
     /// Instead, use the ``View/environment(_:_:)`` view modifier on a view to
     /// set a value for a view hierarchy.
     ///
     /// - Parameter keyPath: A key path to a specific resulting value.
     @inlinable public init(_ keyPath: KeyPath<EnvironmentValues, Value>)

     /// The current value of the environment property.
     ///
     /// The wrapped value property provides primary access to the value's data.
     /// However, you don't access `wrappedValue` directly. Instead, you read the
     /// property variable created with the ``Environment`` property wrapper:
     ///
     ///     @Environment(\.colorScheme) var colorScheme: ColorScheme
     ///
     ///     var body: some View {
     ///         if colorScheme == .dark {
     ///             DarkContent()
     ///         } else {
     ///             LightContent()
     ///         }
     ///     }
     ///
     @inlinable public var wrappedValue: Value { get }
 }

 /// A key for accessing values in the environment.
 ///
 /// You can create custom environment values by extending the
 /// ``EnvironmentValues`` structure with new properties.
 /// First declare a new environment key type and specify a value for the
 /// required ``defaultValue`` property:
 ///
 ///     private struct MyEnvironmentKey: EnvironmentKey {
 ///         static let defaultValue: String = "Default value"
 ///     }
 ///
 /// The Swift compiler automatically infers the associated ``Value`` type as the
 /// type you specify for the default value. Then use the key to define a new
 /// environment value property:
 ///
 ///     extension EnvironmentValues {
 ///         var myCustomValue: String {
 ///             get { self[MyEnvironmentKey.self] }
 ///             set { self[MyEnvironmentKey.self] = newValue }
 ///         }
 ///     }
 ///
 /// Clients of your environment value never use the key directly.
 /// Instead, they use the key path of your custom environment value property.
 /// To set the environment value for a view and all its subviews, add the
 /// ``View/environment(_:_:)`` view modifier to that view:
 ///
 ///     MyView()
 ///         .environment(\.myCustomValue, "Another string")
 ///
 /// As a convenience, you can also define a dedicated view modifier to
 /// apply this environment value:
 ///
 ///     extension View {
 ///         func myCustomValue(_ myCustomValue: String) -> some View {
 ///             environment(\.myCustomValue, myCustomValue)
 ///         }
 ///     }
 ///
 /// This improves clarity at the call site:
 ///
 ///     MyView()
 ///         .myCustomValue("Another string")
 ///
 /// To read the value from inside `MyView` or one of its descendants, use the
 /// ``Environment`` property wrapper:
 ///
 ///     struct MyView: View {
 ///         @Environment(\.myCustomValue) var customValue: String
 ///
 ///         var body: some View {
 ///             Text(customValue) // Displays "Another string".
 ///         }
 ///     }
 ///
 @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
 public protocol EnvironmentKey {

     /// The associated type representing the type of the environment key's
     /// value.
     associatedtype Value

     /// The default value for the environment key.
     static var defaultValue: Self.Value { get }
 }
 */
