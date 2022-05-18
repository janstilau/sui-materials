/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing the details for a landmark.
*/

import SwiftUI

struct LandmarkDetail: View {
    // 从上层传递的值.
    // @EnvironmentObject 其实解决了一些问题, 之前一直有着, 要把一个大的 Model 从上到下不断传递的问题.
    // 使用了这样的一个特殊的机制, 相当于是通过向上遍历的方式, 减少了这个值传递的过程.
    // 对于依赖来说, 使用原来传入的机制, 本来就有依赖. 所以, 现在使用 @EnvironmentObject 并不算是引入了依赖.
    @EnvironmentObject var modelData: ModelData
    var landmark: Landmark
    var landmarkIndex: Int {
        modelData.landmarks.firstIndex(where: { $0.id == landmark.id })!
    }

    /*
     /// A scrollable view.
     
     /// The scroll view displays its content within the scrollable content region.
     /// As the user performs platform-appropriate scroll gestures, the scroll view
     /// adjusts what portion of the underlying content is visible. `ScrollView` can
     /// scroll horizontally, vertically, or both, but does not provide zooming
     /// functionality.
     // 这里说的很清楚, 对于 SwiftUI 来说, 不提供缩放的功能.
     
     /// In the following example, a `ScrollView` allows the user to scroll through
     /// a ``VStack`` containing 100 ``Text`` views. The image after the listing
     /// shows the scroll view's temporarily visible scrollbar at the right; you can
     /// disable it with the `showsIndicators` parameter of the `ScrollView`
     /// initializer.
     ///
     ///     var body: some View {
     ///         ScrollView {
     ///             VStack(alignment: .leading) {
     ///                 ForEach(0..<100) {
     ///                     Text("Row \($0)")
     ///                 }
     ///             }
     ///         }
     ///     }
     ///
     /// To perform programmatic scrolling, wrap one or more scroll views with a
     /// ``ScrollViewReader``.
     public struct ScrollView<Content> : View where Content : View {

         /// The scroll view's content.
         public var content: Content

         /// The scrollable axes of the scroll view.
         ///
         /// The default value is ``Axis/vertical``.
         public var axes: Axis.Set

         /// A value that indicates whether the scroll view displays the scrollable
         /// component of the content offset, in a way that's suitable for the
         /// platform.
         ///
         /// The default is `true`.
         public var showsIndicators: Bool

         /// Creates a new instance that's scrollable in the direction of the given
         /// axis and can show indicators while scrolling.
         ///
         /// - Parameters:
         ///   - axes: The scroll view's scrollable axis. The default axis is the
         ///     vertical axis.
         ///   - showsIndicators: A Boolean value that indicates whether the scroll
         ///     view displays the scrollable component of the content offset, in a way
         ///     suitable for the platform. The default value for this parameter is
         ///     `true`.
         ///   - content: The view builder that creates the scrollable view.
         public init(_ axes: Axis.Set = .vertical, showsIndicators: Bool = true, @ViewBuilder content: () -> Content)

         /// The content and behavior of the scroll view.
         public var body: some View { get }

         /// The type of view representing the body of this view.
         ///
         /// When you create a custom view, Swift infers this type from your
         /// implementation of the required ``View/body-swift.property`` property.
         public typealias Body = some View
     }
     */
    var body: some View {
        /*
         SwiftUI 的 ScrollView 的 ContentSize, 应该是由内部的 ContentView 的和确定的.
         */
        ScrollView(.vertical) {
            MapView(coordinate: landmark.locationCoordinate)
                .ignoresSafeArea(edges: .top)
                .frame(height: 300)

            CircleImage(image: landmark.image)
                .offset(y: -130)
                .padding(.bottom, -130)

            VStack(alignment: .leading) {
                HStack {
                    Text(landmark.name)
                        .font(.title)
                    FavoriteButton(isSet: $modelData.landmarks[landmarkIndex].isFavorite)
                }
                HStack {
                    Text(landmark.park)
                    Spacer()
                    Text(landmark.state)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)

                Divider()

                Text("About \(landmark.name)")
                    .font(.title2)
                Text(landmark.description)
            }
            .padding()
        }
        .navigationTitle(landmark.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static let modelData = ModelData()

    static var previews: some View {
        LandmarkDetail(landmark: modelData.landmarks[0])
            .environmentObject(modelData)
    }
}
