/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The top-level definition of the Landmarks app.
 */

import SwiftUI

@main
struct LandmarksApp: App {
    // 现在, 这份数据是多个 View 都会去使用. 所以, 这份数据, 一定是要被共享起来.
    // 在这里, 是使用了 SwiftUI 的 environmentObject 这种特殊的方式, 来进行
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
            // environmentObject 的参数有着一个要求, 就是要ObservableObject
        }
    }
}
