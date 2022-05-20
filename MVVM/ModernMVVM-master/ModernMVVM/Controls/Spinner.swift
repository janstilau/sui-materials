//
//  Spinner.swift
//  ModernMVVM
//
//  Created by Vadym Bulavin on 2/18/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import SwiftUI
import UIKit

struct Spinner: UIViewRepresentable {
    let isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: style)
        spinner.hidesWhenStopped = true
        return spinner
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

/*
 
 /// A wrapper for a UIKit view that you use to integrate that view into your
 /// SwiftUI view hierarchy.
 
 /// Use a ``UIViewRepresentable`` instance to create and manage a object in your SwiftUI
 /// interface. Adopt this protocol in one of your app's custom instances, and
 /// use its methods to create, update, and tear down your view. The creation and
 /// update processes parallel the behavior of SwiftUI views, and you use them to
 /// configure your view with your app's current state information. Use the
 /// teardown process to remove your view cleanly from your SwiftUI. For example,
 /// you might use the teardown process to notify other objects that the view is
 /// disappearing.
 
 
 /// To add your view into your SwiftUI interface, create your
 /// ``UIViewRepresentable`` instance and add it to your SwiftUI interface. The
 /// system calls the methods of your representable instance at appropriate times
 /// to create and update the view. The following example shows the inclusion of
 /// a custom `MyRepresentedCustomView` structure in the view hierarchy.
 ///
 ///     struct ContentView: View {
 ///        var body: some View {
 ///           VStack {
 ///              Text("Global Sales")
 ///              MyRepresentedCustomView()
 ///           }
 ///        }
 ///     }
 
 /// The system doesn't automatically communicate changes occurring within your
 /// view to other parts of your SwiftUI interface.  When you want your view to
 /// coordinate with other SwiftUI views, you must provide a
 /// ``NSViewControllerRepresentable/Coordinator`` instance to facilitate those
 /// interactions. For example, you use a coordinator to forward target-action
 /// and delegate messages from your view to any SwiftUI views.
 
 public protocol UIViewRepresentable : View where Self.Body == Never {

     /// The type of view to present.
     associatedtype UIViewType : UIView

     /// Creates the view object and configures its initial state.
     ///
     /// You must implement this method and use it to create your view object.
     /// Configure the view using your app's current data and contents of the
     /// `context` parameter. The system calls this method only once, when it
     /// creates your view for the first time. For all subsequent updates, the
     /// system calls the ``UIViewRepresentable/updateUIView(_:context:)``
     /// method.
     ///
     /// - Parameter context: A context structure containing information about
     ///   the current state of the system.
     ///
     /// - Returns: Your UIKit view configured with the provided information.
     func makeUIView(context: Self.Context) -> Self.UIViewType

     /// Updates the state of the specified view with new information from
     /// SwiftUI.
     ///
     /// When the state of your app changes, SwiftUI updates the portions of your
     /// interface affected by those changes. SwiftUI calls this method for any
     /// changes affecting the corresponding UIKit view. Use this method to
     /// update the configuration of your view to match the new state information
     /// provided in the `context` parameter.
     ///
     /// - Parameters:
     ///   - uiView: Your custom view object.
     ///   - context: A context structure containing information about the current
     ///     state of the system.
     func updateUIView(_ uiView: Self.UIViewType, context: Self.Context)

     /// Cleans up the presented UIKit view (and coordinator) in anticipation of
     /// their removal.
     ///
     /// Use this method to perform additional clean-up work related to your
     /// custom view. For example, you might use this method to remove observers
     /// or update other parts of your SwiftUI interface.
     ///
     /// - Parameters:
     ///   - uiView: Your custom view object.
     ///   - coordinator: The custom coordinator instance you use to communicate
     ///     changes back to SwiftUI. If you do not use a custom coordinator, the
     ///     system provides a default instance.
     static func dismantleUIView(_ uiView: Self.UIViewType, coordinator: Self.Coordinator)

     /// A type to coordinate with the view.
     associatedtype Coordinator = Void

     /// Creates the custom instance that you use to communicate changes from
     /// your view to other parts of your SwiftUI interface.
     ///
     /// Implement this method if changes to your view might affect other parts
     /// of your app. In your implementation, create a custom Swift instance that
     /// can communicate with other parts of your interface. For example, you
     /// might provide an instance that binds its variables to SwiftUI
     /// properties, causing the two to remain synchronized. If your view doesn't
     /// interact with other parts of your app, providing a coordinator is
     /// unnecessary.
     ///
     /// SwiftUI calls this method before calling the
     /// ``UIViewRepresentable/makeUIView(context:)`` method. The system provides
     /// your coordinator either directly or as part of a context structure when
     /// calling the other methods of your representable instance.
     func makeCoordinator() -> Self.Coordinator

     typealias Context = UIViewRepresentableContext<Self>
 }
 */
