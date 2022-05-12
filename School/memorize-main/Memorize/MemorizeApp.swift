//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Sergey Maslennikov on 23.11.2020.
//

import SwiftUI
/*
 
 /// A type that represents part of your app's user interface and provides
 /// modifiers that you use to configure views.
 
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
 /// other custom views that you define, into a hierarchy of views.
 
 /// The `View` protocol provides a set of modifiers — protocol
 /// methods with default implementations — that you use to configure
 /// views in the layout of your app. Modifiers work by wrapping the
 /// view instance on which you call them in another view with the specified
 /// characteristics.

 /// For example, adding the ``View/opacity(_:)`` modifier to a
 /// text view returns a new view with some amount of transparency:
 ///
 ///     Text("Hello, World!")
 ///         .opacity(0.5) // Display partially transparent text.
 ///
 /// The complete list of default modifiers provides a large set of controls
 /// for managing views.

 /// You can also collect groups of default modifiers into new,
 /// custom view modifiers for easy reuse.
 
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
     @ViewBuilder var body: Self.Body { get }
 }
 */

/*
 EmojiMemoryGameView
 VStack<TupleView<(ModifiedContent<HStack<TupleView<(Button<Text>, Text)>>, _PaddingLayout>, ModifiedContent<ModifiedContent<Grid<Card, ModifiedContent<ModifiedContent<CardView, AddGestureModifier<_EndedGesture<TapGesture>>>, _PaddingLayout>>, _PaddingLayout>, _EnvironmentKeyWritingModifier<Optional<Color>>>)>>

 EmojiMemoryGameView 的类型信息, 是 EmojiMemoryGameView
 但是它的 Body 返回的类型信息, 是 VStack 类型.
 */

@main
struct MemorizeApp: App {
    var body: some Scene {
        WindowGroup {
            /*
             EmojiMemoryGameView
             */
            EmojiMemoryGameView(viewModel: EmojiMemoryGame()).debug()
            
            // Text
            // Text("hehehe").debug()
        }
    }
}
