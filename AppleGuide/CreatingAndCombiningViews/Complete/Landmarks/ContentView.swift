/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A view showing the details for a landmark.
 */

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            /*
             extension View {
                 /// Expands the view out of its safe area.
                 ///
                 /// - Parameters:
                 ///   - regions: the kinds of rectangles removed from the safe area
                 ///     that should be ignored (i.e. added back to the safe area
                 ///     of the new child view).
                 ///   - edges: the edges of the view that may be outset, any edges
                 ///     not in this set will be unchanged, even if that edge is
                 ///     abutting a safe area listed in `regions`.
                 ///
                 /// - Returns: a new view with its safe area expanded.
                 ///
                 @inlinable public func ignoresSafeArea(_ regions: SafeAreaRegions = .all, edges: Edge.Set = .all) -> some View

             }
             */
            MapView()
                .ignoresSafeArea(edges: .top)
                .frame(height: 300)
            
            CircleImage()
            // Offset 并不会修改布局
                .offset(y: -130)
            // padding 会修改布局, 使用负数, 可以导致布局向内坍塌.
                .padding(.bottom, -130)
            
            VStack(alignment: .leading) {
                Text("JustinLauKingdom")
                    .font(.title)
                    .padding(.all)
                
                HStack {
                    Text("Joshua Tree National Park")
                    Spacer()
                    Text("California")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                /*
                 /// A visual element that can be used to separate other content.
                 /// When contained in a stack, the divider extends across the minor axis of the
                 /// stack, or horizontally when not in a stack.
                 @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
                 public struct Divider : View {

                     public init()
                     public typealias Body = Never
                 }
                 */
                Divider()
                
                Text("About Turtle Rock")
                    .font(.title2)
                Text("Descriptive text goes here.")
            }
            .padding()
            
            Spacer()
        }
    }
}

/*
 /// A flexible space that expands along the major axis of its containing stack
 /// layout, or on both axes if not contained in a stack.
 ///
 /// A spacer creates an adaptive view with no content that expands as much as
 /// it can. For example, when placed within an ``HStack``, a spacer expands
 /// horizontally as much as the stac-6321k allows, moving sibling views out of the
 /// way, within the limits of the stack's size.
 /// SwiftUI sizes a stack that doesn't contain a spacer up to the combined
 /// ideal widths of the content of the stack's child views.
 ///
 /// The following example provides a simple checklist row to illustrate how you
 /// can use a spacer:
 ///
 ///     struct ChecklistRow: View {
 ///         let name: String
 ///
 ///         var body: some View {
 ///             HStack {
 ///                 Image(systemName: "checkmark")
 ///                 Text(name)
 ///             }
 ///             .border(Color.blue)
 ///         }
 ///     }
 ///
 /// Adding a spacer before the image creates an adaptive view with no content
 /// that expands to push the image and text to the right side of the stack.
 /// The stack also now expands to take as much space as the parent view allows,
 /// shown by the blue border that indicates the boundary of the stack:
 ///
 ///     struct ChecklistRow: View {
 ///         let name: String
 ///
 ///         var body: some View {
 ///             HStack {
 ///                 Spacer()
 ///                 Image(systemName: "checkmark")
 ///                 Text(name)
 ///             }
 ///             .border(Color.blue)
 ///         }
 ///     }
 ///
 /// Moving the spacer between the image and the name pushes those elements to
 /// the left and right sides of the ``HStack``, respectively. Because the stack
 /// contains the spacer, it expands to take as much horizontal space as the
 /// parent view allows; the blue border indicates its size:
 ///
 ///     struct ChecklistRow: View {
 ///         let name: String
 ///
 ///         var body: some View {
 ///             HStack {
 ///                 Image(systemName: "checkmark")
 ///                 Spacer()
 ///                 Text(name)
 ///             }
 ///             .border(Color.blue)
 ///         }
 ///     }
 ///
 ///
 /// Adding two spacer views on the outside of the stack leaves the image and
 /// text together, while the stack expands to take as much horizontal space
 /// as the parent view allows:
 ///
 ///     struct ChecklistRow: View {
 ///         let name: String
 ///
 ///         var body: some View {
 ///             HStack {
 ///                 Spacer()
 ///                 Image(systemName: "checkmark")
 ///                 Text(name)
 ///                 Spacer()
 ///             }
 ///             .border(Color.blue)
 ///         }
 ///     }
 @frozen public struct Spacer {

     /// The minimum length this spacer can be shrunk to, along the axis or axes
     /// of expansion.
     ///
     /// If `nil`, the system default spacing between views is used.
     public var minLength: CGFloat?

     @inlinable public init(minLength: CGFloat? = nil)

     /// The type of view representing the body of this view.
     ///
     /// When you create a custom view, Swift infers this type from your
     /// implementation of the required ``View/body-swift.property`` property.
     public typealias Body = Never
 }
 */
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        Spacer()
    }
}
