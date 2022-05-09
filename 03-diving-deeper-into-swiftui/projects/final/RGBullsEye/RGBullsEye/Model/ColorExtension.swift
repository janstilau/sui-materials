import Foundation
import SwiftUI

extension Color {
    /// Create a Color view from an RGB object.
    ///   - parameters:
    ///     - rgb: The RGB object.
    init(rgbStruct rgb: RGB) {
        self.init(red: rgb.red, green: rgb.green, blue: rgb.blue)
    }
}

// 在类型下, 将相关的常量类型专门的定义出来, 是一个优雅的代码组织的方式.
extension Color {
    static let customPurple = Color("Purple")
    static let element = Color("Element")
    static let highlight = Color("Highlight")
    static let shadow = Color("Shadow")
}
