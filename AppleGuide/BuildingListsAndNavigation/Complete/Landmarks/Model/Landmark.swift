/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A representation of a single landmark.
 */

import Foundation
import SwiftUI
import CoreLocation

// 使用 Model 来做 View 的管理, 这在哪里都是正确的.
struct Landmark: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var park: String
    var state: String
    var description: String
    
    // imageName 是一个私有属性.
    private var imageName: String
    var image: Image {
        Image(imageName)
    }
    
    // 真正的数据, 使用了 Coordinates 进行存储.
    // 但是, 外界感兴趣的, 仅仅是 CLLocationCoordinate2D 这样的通用数据结构.
    private var coordinates: Coordinates
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }
}

extension Landmark {
    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }
}
