/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A view showing a list of landmarks.
 */

import SwiftUI

/*
 A property wrapper type for an observable object supplied by a parent or ancestor view.
 Declaration
 @frozen @propertyWrapper struct EnvironmentObject<ObjectType> where ObjectType : ObservableObject
 Overview
 An environment object invalidates the current view whenever the observable object changes. If you declare a property as an environment object, be sure to set a corresponding model object on an ancestor view by calling its environmentObject(_:) modifier.
 */
struct LandmarkList: View {
    // @EnvironmentObject 限制了, 他所修饰的对象, 必须是 ObservableObject 的.
    // 这样, EnvironmentObject 可以直接引起 View 的更新操作.
    @EnvironmentObject var modelData: ModelData
    @State private var showFavoritesOnly = false
    
    var filteredLandmarks: [Landmark] {
        // 为什么不把 showFavoritesOnly 的判断提出来.
        modelData.landmarks.filter { landmark in
            (!showFavoritesOnly || landmark.isFavorite)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                // ViewBuilder 的操作.
                // List 真正存储的, 就是 Toggle 和 ForEach 两份数据.
                // ForEach 对应的 View 的真正创建, 是在 ViewTree 真正生成的时候.
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Favorites only")
                }
                
                ForEach(filteredLandmarks) { landmark in
                    NavigationLink {
                        LandmarkDetail(landmark: landmark)
                    } label: {
                        LandmarkRow(landmark: landmark)
                    }
                }
            }
            .navigationTitle("Landmarks")
        }
    }
}

/*
 extension View {
     /// Configures the view's title for purposes of navigation.
     
     /// A view's navigation title is used to visually display
     /// the current navigation state of an interface.
 
     /// On iOS and watchOS, when a view is navigated to inside
     /// of a navigation view, that view's title is displayed
     /// in the navigation bar. On iPadOS, the primary destination's
     /// navigation title is reflected as the window's title in the
     /// App Switcher. Similarly on macOS, the primary destination's title
     /// is used as the window title in the titlebar, Windows menu
     /// and Mission Control.
     ///
     /// - Parameter title: The title to display.
     public func navigationTitle(_ title: Text) -> some View


     /// Configures the view's title for purposes of navigation,
     /// using a localized string.
     ///
     /// A view's navigation title is used to visually display
     /// the current navigation state of an interface.
     /// On iOS and watchOS, when a view is navigated to inside
     /// of a navigation view, that view's title is displayed
     /// in the navigation bar. On iPadOS, the primary destination's
     /// navigation title is reflected as the window's title in the
     /// App Switcher. Similarly on macOS, the primary destination's title
     /// is used as the window title in the titlebar, Windows menu
     /// and Mission Control.
     ///
     /// - Parameter titleKey: The key to a localized string to display.
     public func navigationTitle(_ titleKey: LocalizedStringKey) -> some View


     /// Configures the view's title for purposes of navigation, using a string.
     ///
     /// A view's navigation title is used to visually display
     /// the current navigation state of an interface.
     /// On iOS and watchOS, when a view is navigated to inside
     /// of a navigation view, that view's title is displayed
     /// in the navigation bar. On iPadOS, the primary destination's
     /// navigation title is reflected as the window's title in the
     /// App Switcher. Similarly on macOS, the primary destination's title
     /// is used as the window title in the titlebar, Windows menu
     /// and Mission Control.
     ///
     /// - Parameter title: The string to display.
     public func navigationTitle<S>(_ title: S) -> some View where S : StringProtocol

 }
 */

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkList()
            .environmentObject(ModelData())
    }
}
