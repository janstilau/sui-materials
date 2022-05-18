/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that displays a rotated version of a badge symbol.
*/

import SwiftUI

/*
 extension View {
     /// Rotates this view's rendered output around the specified point.
     ///
     /// Use `rotationEffect(_:anchor:)` to rotate the view by a specific amount.
     
     /// In the example below, the text is rotated by 22˚.
     ///
     ///     Text("Rotation by passing an angle in degrees")
     ///         .rotationEffect(.degrees(22))
     ///         .border(Color.gray)
     ///
     /// ![A screenshot showing rotation effect rotating the text 22 degrees with
     /// respect to its view.](SwiftUI-View-rotationEffect.png)
     ///
     /// - Parameters:
     ///   - angle: The angle at which to rotate the view.
     ///   - anchor: The location with a default of ``UnitPoint/center`` that
     ///     defines a point at which the rotation is anchored.
     public func rotationEffect(_ angle: Angle, anchor: UnitPoint = .center) -> some View
 }
 */
struct RotatedBadgeSymbol: View {
    let angle: Angle

    var body: some View {
        BadgeSymbol()
            .padding(-60)
            .rotationEffect(angle, anchor: .bottom)
    }
}

struct RotatedBadgeSymbol_Previews: PreviewProvider {
    static var previews: some View {
        RotatedBadgeSymbol(angle: Angle(degrees: 5))
    }
}
