/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The top-level definition of the Landmarks app.
 */

import SwiftUI

@main
struct LandmarksApp: App {
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
            // environmentObject 的参数有着一个要求, 就是要ObservableObject
        }
    }
}
