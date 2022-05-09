import SwiftUI

/*
 Swift UI, 本质上还是 Swift 的代码, 所以各种 Swift 的特性, 其实都可以添加到上面. 
 */
 
extension View {
    /// Simulate shining a light on the northwest edge of a view.
    /// Light shadow on the northwest edge, dark shadow on the southeast edge.
    ///   - parameters:
    ///     - radius: The size of the shadow
    ///     - offset: The value used for (-x, -y) and (x, y) offsets
    func northWestShadow(
        radius: CGFloat = 16,
        offset: CGFloat = 6
    ) -> some View {
        return self
            .shadow(
                color: .highlight, radius: radius, x: -offset, y: -offset)
            .shadow(
                color: .shadow, radius: radius, x: offset, y: offset)
    }
    
    /// Simulate shining a light on the southeast edge of a view.
    /// Light shadow on the southeast edge, dark shadow on the northwest edge.
    ///   - parameters:
    ///     - radius: The size of the shadow
    ///     - offset: The value used for (-x, -y) and (x, y) offsets
    func southEastShadow(
        radius: CGFloat = 16,
        offset: CGFloat = 6
    ) -> some View {
        return self
            .shadow(
                color: .shadow, radius: radius, x: -offset, y: -offset)
            .shadow(
                color: .highlight, radius: radius, x: offset, y: offset)
    }
}
