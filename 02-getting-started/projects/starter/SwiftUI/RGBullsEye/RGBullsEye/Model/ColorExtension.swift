import Foundation
import SwiftUI

// 这不是 UIColor, 而是 ColorView.
// 给 ColorView 增加了一个接受 RGB 类型参数的初始化方法.
extension Color {
    /// Create a Color view from an RGB object.
    ///   - parameters:
    ///     - rgb: The RGB object.
    init(rgbStruct rgb: RGB) {
        self.init(red: rgb.red, green: rgb.green, blue: rgb.blue)
    }
}
