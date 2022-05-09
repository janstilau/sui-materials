import Foundation
import SwiftUI

// 这个 Color, 并不是 UIColor, 而是 SwiftUI 里面的 ColorView.
extension Color {
    /// Create a Color view from an RGB object.
    ///   - parameters:
    ///     - rgb: The RGB object.
    init(rgbStruct rgb: RGB) {
        self.init(red: rgb.red, green: rgb.green, blue: rgb.blue)
    }
}
