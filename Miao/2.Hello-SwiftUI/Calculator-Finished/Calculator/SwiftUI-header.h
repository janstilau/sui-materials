//
//  SwiftUI-header.h
//  Calculator
//
//  Created by JustinLau on 2022/5/10.
//  Copyright © 2022 OneV's Den. All rights reserved.
//

#ifndef SwiftUI_header_h
#define SwiftUI_header_h

/*
 
 /// A type that represents part of your app's user interface and provides
 /// modifiers that you use to configure views.
 
 // 一定要和 UIKit 区分开. Body 里面, 是对于展示的描述信息, 并不是像 UIKit 那样, 进行构建的过程.
 // 这是一个计算类型, 每次相关的数据源发生改变, 都会重新调用该属性, 来获取当前 View 的最新展示状态.
 /// You create custom views by declaring types that conform to the `View`
 /// protocol. Implement the required ``View/body-swift.property`` computed
 /// property to provide the content for your custom view.
 ///
 ///     struct MyView: View {
 ///         var body: some View {
 ///             Text("Hello, World!")
 ///         }
 ///     }
 
 /// Assemble the view's body by combining one or more of the built-in views
 /// provided by SwiftUI, like the ``Text`` instance in the example above, plus
 /// other custom views that you define, into a hierarchy of views. For more
 /// information about creating custom views, see <doc:Declaring-a-Custom-View>.
 
 /// The `View` protocol provides a set of modifiers — protocol
 /// methods with default implementations — that you use to configure
 /// views in the layout of your app. Modifiers work by wrapping the
 /// view instance on which you call them in another view with the specified
 /// characteristics, as described in <doc:Configuring-Views>.
 /// For example, adding the ``View/opacity(_:)`` modifier to a
 /// text view returns a new view with some amount of transparency:
 ///
 ///     Text("Hello, World!")
 ///         .opacity(0.5) // Display partially transparent text.
 
 /// The complete list of default modifiers provides a large set of controls
 /// for managing views.
 /// For example, you can fine tune <doc:View-Layout>,
 /// add <doc:View-Accessibility> information,
 /// and respond to <doc:View-Input-and-Events>.
 /// You can also collect groups of default modifiers into new,
 /// custom view modifiers for easy reuse.
 @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
 public protocol View {

     /// The type of view representing the body of this view.
     ///
     /// When you create a custom view, Swift infers this type from your
     /// implementation of the required ``View/body-swift.property`` property.
     associatedtype Body : View

     /// The content and behavior of the view.
     ///
     /// When you implement a custom view, you must implement a computed
     /// `body` property to provide the content for your view. Return a view
     /// that's composed of built-in views that SwiftUI provides, plus other
     /// composite views that you've already defined:
     ///
     ///     struct MyView: View {
     ///         var body: some View {
     ///             Text("Hello, World!")
     ///         }
     ///     }
     ///
     /// For more information about composing views and a view hierarchy,
     /// see <doc:Declaring-a-Custom-View>.
     @ViewBuilder var body: Self.Body { get }
 }

 */


#endif /* SwiftUI_header_h */
