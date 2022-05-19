//
//  EmojiArtApp.swift
//  Shared
//
//  Created by CS193p Instructor on 5/26/21.
//

import SwiftUI

/*
 /// A type that represents the structure and behavior of an app.
 ///
 /// Create an app by declaring a structure that conforms to the `App` protocol.
 /// Implement the required ``SwiftUI/App/body-swift.property`` computed property
 /// to define the app's content:
 ///
 ///     @main
 ///     struct MyApp: App {
 ///         var body: some Scene {
 ///             WindowGroup {
 ///                 Text("Hello, world!")
 ///             }
 ///         }
 ///     }
 /// your custom `App` protocol conformer provides the
 /// entry point into your app. The protocol provides a default implementation of
 /// the ``SwiftUI/App/main()`` method that the system calls to launch your app.
 /// You can have exactly one entry point among all of your app's files.
 
 /// Compose the app's body from instances that conform to the ``SwiftUI/Scene``
 /// protocol. Each scene contains the root view of a view hierarchy and has a
 /// life cycle managed by the system. SwiftUI provides some concrete scene types
 /// to handle common scenarios, like for displaying documents or settings. You
 /// can also create custom scenes.
 ///
 ///     @main
 ///     struct Mail: App {
 ///         var body: some Scene {
 ///             WindowGroup {
 ///                 MailViewer()
 ///             }
 ///             Settings {
 ///                 SettingsView()
 ///             }
 ///         }
 ///     }
 
 /// You can declare state in your app to share across all of its scenes. For
 /// example, you can use the ``SwiftUI/StateObject`` attribute to initialize a
 /// data model, and then provide that model on a view input as an
 /// ``SwiftUI/ObservedObject`` or through the environment as an
 /// ``SwiftUI/EnvironmentObject`` to scenes in the app:
 ///
 ///     @main
 ///     struct Mail: App {
 ///         @StateObject private var model = MailModel()
 ///
 ///         var body: some Scene {
 ///             WindowGroup {
 ///                 MailViewer()
 ///                     .environmentObject(model) // Passed through the environment.
 ///             }
 ///             Settings {
 ///                 SettingsView(model: model) // Passed as an observed object.
 ///             }
 ///         }
 ///     }
 
 @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
 public protocol App {

     /// The type of scene representing the content of the app.
     ///
     /// When you create a custom app, Swift infers this type from your
     /// implementation of the required ``SwiftUI/App/body-swift.property``
     /// property.
     associatedtype Body : Scene

     /// The content and behavior of the app.
     ///
     /// For any app that you create, provide a computed `body` property that
     /// defines your app's scenes, which are instances that conform to the
     /// ``SwiftUI/Scene`` protocol. For example, you can create a simple app
     /// with a single scene containing a single view:
     ///
     ///     @main
     ///     struct MyApp: App {
     ///         var body: some Scene {
     ///             WindowGroup {
     ///                 Text("Hello, world!")
     ///             }
     ///         }
     ///     }
     ///
     /// Swift infers the app's ``SwiftUI/App/Body-swift.associatedtype``
     /// associated type based on the scene provided by the `body` property.
     @SceneBuilder var body: Self.Body { get }

     /// Creates an instance of the app using the body that you define for its
     /// content.
     ///
     /// Swift synthesizes a default initializer for structures that don't
     /// provide one. You typically rely on the default initializer for
     /// your app.
     init()
 }
 */

/*
 /// A part of an app's user interface with a life cycle managed by the
 /// system.
 
 /// You create an ``SwiftUI/App`` by combining one or more instances
 /// that conform to the `Scene` protocol in the app's
 /// ``SwiftUI/App/body-swift.property``. You can use the built-in scenes that
 /// SwiftUI provides, like ``SwiftUI/WindowGroup``, along with custom scenes
 /// that you compose from other scenes. To create a custom scene, declare a
 /// type that conforms to the `Scene` protocol. Implement the required
 /// ``SwiftUI/Scene/body-swift.property`` computed property and provide the
 /// content for your custom scene:
 ///
 ///     struct MyScene: Scene {
 ///         var body: some Scene {
 ///             WindowGroup {
 ///                 MyRootView()
 ///             }
 ///         }
 ///     }
 
 /// A scene acts as a container for a view hierarchy that you want to display
 /// to the user. The system decides when and how to present the view hierarchy
 /// in the user interface in a way that's platform-appropriate and dependent
 /// on the current state of the app. For example, for the window group shown
 /// above, the system lets the user create or remove windows that contain
 /// `MyRootView` on platforms like macOS and iPadOS. On other platforms, the
 /// same view hierarchy might consume the entire display when active.
 ///
 /// Read the ``SwiftUI/EnvironmentValues/scenePhase`` environment
 /// value from within a scene or one of its views to check whether a scene is
 /// active or in some other state. You can create a property that contains the
 /// scene phase, which is one of the values in the ``SwiftUI/ScenePhase``
 /// enumeration, using the ``SwiftUI/Environment`` attribute:
 ///
 ///     struct MyScene: Scene {
 ///         @Environment(\.scenePhase) private var scenePhase
 ///
 ///         // ...
 ///     }
 
 /// The `Scene` protocol provides scene modifiers, defined as protocol methods
 /// with default implementations, that you use to configure a scene. For
 /// example, you can use the ``SwiftUI/Scene/onChange(of:perform:)`` modifier to
 /// trigger an action when a value changes. The following code empties a cache
 /// when all of the scenes in the window group have moved to the background:
 ///
 ///     struct MyScene: Scene {
 ///         @Environment(\.scenePhase) private var scenePhase
 ///         @StateObject private var cache = DataCache()
 ///
 ///         var body: some Scene {
 ///             WindowGroup {
 ///                 MyRootView()
 ///             }
 ///             .onChange(of: scenePhase) { newScenePhase in
 ///                 if newScenePhase == .background {
 ///                     cache.empty()
 ///                 }
 ///             }
 ///         }
 ///     }
 @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
 public protocol Scene {

     /// The type of scene that represents the body of this scene.
     ///
     /// When you create a custom scene, Swift infers this type from your
     /// implementation of the required ``SwiftUI/Scene/body-swift.property``
     /// property.
     associatedtype Body : Scene

     /// The content and behavior of the scene.
     ///
     /// For any scene that you create, provide a computed `body` property that
     /// defines the scene as a composition of other scenes. You can assemble a
     /// scene from built-in scenes that SwiftUI provides, as well as other
     /// scenes that you've defined.
     ///
     /// Swift infers the scene's ``SwiftUI/Scene/Body-swift.associatedtype``
     /// associated type based on the contents of the `body` property.
     @SceneBuilder var body: Self.Body { get }
 }
 */
@main
struct EmojiArtApp: App {
    @StateObject var paletteStore = PaletteStore(named: "Default")
    
    var body: some Scene {
        DocumentGroup(newDocument: { EmojiArtDocument() }) { config in
            EmojiArtDocumentView(document: config.document)
                .environmentObject(paletteStore)
        }
    }
}
