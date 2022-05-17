/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A single row to be displayed in a list of landmarks.
 */

import SwiftUI

/*
 /// A type that collects multiple instances of a content type --- like views,
 /// scenes, or commands --- into a single unit.
 
 /// Use a group to collect multiple views into a single instance, without
 /// affecting the layout of those views, like an ``SwiftUI/HStack``,
 /// ``SwiftUI/VStack``, or ``SwiftUI/Section`` would. After creating a group,
 /// any modifier you apply to the group affects all of that group's members.
 /// For example, the following code applies the ``SwiftUI/Font/headline``
 /// font to three views in a group.
 ///
 ///     Group {
 ///         Text("SwiftUI")
 ///         Text("Combine")
 ///         Text("Swift System")
 ///     }
 ///     .font(.headline)
 ///
 /// Because you create a group of views with a ``SwiftUI/ViewBuilder``, you can
 /// use the group's initializer to produce different kinds of views from a
 /// conditional, and then optionally apply modifiers to them. The following
 /// example uses a `Group` to add a navigation bar title,
 /// regardless of the type of view the conditional produces:
 ///
 ///     Group {
 ///         if isLoggedIn {
 ///             WelcomeView()
 ///         } else {
 ///             LoginView()
 ///         }
 ///     }
 ///     .navigationBarTitle("Start")
 
 /// The modifier applies to all members of the group --- and not to the group
 /// itself. For example, if you apply ``View/onAppear(perform:)`` to the above
 /// group, it applies to all of the views produced by the `if isLoggedIn`
 /// conditional, and it executes every time `isLoggedIn` changes.
 ///
 /// Because a group of views itself is a view, you can compose a group within
 /// other view builders, including nesting within other groups. This allows you
 /// to add large numbers of views to different view builder containers. The
 /// following example uses a `Group` to collect 10 ``SwiftUI/Text`` instances,
 /// meaning that the vertical stack's view builder returns only two views ---
 /// the group, plus an additional ``SwiftUI/Text``:
 ///
 ///     var body: some View {
 ///         VStack {
 ///             Group {
 ///                 Text("1")
 ///                 Text("2")
 ///                 Text("3")
 ///                 Text("4")
 ///                 Text("5")
 ///                 Text("6")
 ///                 Text("7")
 ///                 Text("8")
 ///                 Text("9")
 ///                 Text("10")
 ///             }
 ///             Text("11")
 ///         }
 ///     }
 ///
 /// You can initialize groups with several types other than ``SwiftUI/View``,
 /// such as ``SwiftUI/Scene`` and ``SwiftUI/ToolbarContent``. The closure you
 /// provide to the group initializer uses the corresponding builder type
 /// (``SwiftUI/SceneBuilder``, ``SwiftUI/ToolbarContentBuilder``, and so on),
 /// and the capabilities of these builders vary between types. For example,
 /// you can use groups to return large numbers of scenes or toolbar content
 /// instances, but not to return different scenes or toolbar content based
 /// on conditionals.
 @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
 @frozen public struct Group<Content> {

     /// The type for the internal content of this `AccessibilityRotorContent`.
     public typealias Body = Never
 }
 */


/*
 extension Image {

     /// The modes that SwiftUI uses to resize an image to fit within its containing view.
     public enum ResizingMode {

         /// A mode to repeat the image at its original size, as many times as
         /// necessary to fill the available space.
         case tile

         /// A mode to enlarge or reduce the size of an image so that it fills the available space.
         case stretch

         /// Returns a Boolean value indicating whether two values are equal.
         ///
         /// Equality is the inverse of inequality. For any values `a` and `b`,
         /// `a == b` implies that `a != b` is `false`.
         ///
         /// - Parameters:
         ///   - lhs: A value to compare.
         ///   - rhs: Another value to compare.
         public static func == (a: Image.ResizingMode, b: Image.ResizingMode) -> Bool

         /// Hashes the essential components of this value by feeding them into the
         /// given hasher.
         ///
         /// Implement this method to conform to the `Hashable` protocol. The
         /// components used for hashing must be the same as the components compared
         /// in your type's `==` operator implementation. Call `hasher.combine(_:)`
         /// with each of these components.
         ///
         /// - Important: Never call `finalize()` on `hasher`. Doing so may become a
         ///   compile-time error in the future.
         ///
         /// - Parameter hasher: The hasher to use when combining the components
         ///   of this instance.
         public func hash(into hasher: inout Hasher)

         /// The hash value.
         ///
         /// Hash values are not guaranteed to be equal across different executions of
         /// your program. Do not save hash values to use during a future execution.
         ///
         /// - Important: `hashValue` is deprecated as a `Hashable` requirement. To
         ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
         public var hashValue: Int { get }
     }

     /// Sets the mode by which SwiftUI resizes an image to fit its space.
     /// - Parameters:
     ///   - capInsets: Inset values that indicate a portion of the image that
     ///   SwiftUI doesn't resize.
     ///   - resizingMode: The mode by which SwiftUI resizes the image.
     /// - Returns: An image, with the new resizing behavior set.
     public func resizable(capInsets: EdgeInsets = EdgeInsets(), resizingMode: Image.ResizingMode = .stretch) -> Image
 }
 */
struct LandmarkRow: View {
    var landmark: Landmark
    
    var body: some View {
        HStack {
            landmark.image
                .resizable()
                .frame(width: 50, height: 50)
            Text(landmark.name)
            
            Spacer()
            
            if landmark.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
    }
}

struct LandmarkRow_Previews: PreviewProvider {
    static var landmarks = ModelData().landmarks
    
    static var previews: some View {
        Group {
            LandmarkRow(landmark: landmarks[0])
            LandmarkRow(landmark: landmarks[1])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
