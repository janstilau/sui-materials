/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The elevation, heart rate, and pace of a hike plotted on a graph.
 */

import SwiftUI

extension Animation {
    static func ripple(index: Int) -> Animation {
        Animation.spring(dampingFraction: 0.5)
            .speed(2)
            .delay(0.03 * Double(index))
    }
}

struct HikeGraph: View {
    var hike: Hike
    // 如果在 OC 里面, 这就是一个字符串值.
    // 在 Swift 里面, 有了更加友好和确定的表现方式.
    var path: KeyPath<Hike.Observation, Range<Double>>
    
    // 计算属性, 根据 Path 的不同, 返回不同的颜色.
    // switch case, 还能用到 KeyPath 中.
    var color: Color {
        switch path {
        case \.elevation:
            return .gray
        case \.heartRate:
            return Color(hue: 0, saturation: 0.5, brightness: 0.7)
        case \.pace:
            return Color(hue: 0.7, saturation: 0.4, brightness: 0.7)
        default:
            return .black
        }
    }
    
    var body: some View {
        let data = hike.observations
        let overallRange = rangeOfRanges(data.lazy.map { $0[keyPath: path] })
        let maxMagnitude = data.map { magnitude(of: $0[keyPath: path]) }.max()!
        let heightRatio = 1 - CGFloat(maxMagnitude / magnitude(of: overallRange))
        
        return GeometryReader { proxy in
            HStack(alignment: .bottom,
                   spacing: proxy.size.width / 120) {
                ForEach(Array(data.enumerated()),
                        id: \.offset) { index, observation in
                    GraphCapsule(
                        index: index,
                        color: color,
                        height: proxy.size.height,
                        range: observation[keyPath: path],
                        overallRange: overallRange
                    )
                        .animation(.ripple(index: index))
                }
                .offset(x: 0, y: proxy.size.height * heightRatio)
            }
        }
    }
}

/*
 
 extension View {
     /// Offset this view by the horizontal and vertical amount specified in the
     /// offset parameter.
     
     /// Use `offset(_:)` to shift the displayed contents by the amount
     /// specified in the `offset` parameter.
     
     /// The original dimensions of the view aren't changed by offsetting the
     /// contents; in the example below the gray border drawn by this view
     /// surrounds the original position of the text:
     ///
     ///     Text("Offset by passing CGSize()")
     ///         .border(Color.green)
     ///         .offset(CGSize(width: 20, height: 25))
     ///         .border(Color.gray)
     ///
     /// ![A screenshot showing a view that offset from its original position a
     /// CGPoint to specify the x and y offset.](SwiftUI-View-offset.png)
     ///
     /// - Parameter offset: The distance to offset this view.
     ///
     /// - Returns: A view that offsets this view by `offset`.
     @inlinable public func offset(_ offset: CGSize) -> some View


     /// Offset this view by the specified horizontal and vertical distances.
     ///
     /// Use `offset(x:y:)` to shift the displayed contents by the amount
     /// specified in the `x` and `y` parameters.
     ///
     /// The original dimensions of the view aren't changed by offsetting the
     /// contents; in the example below the gray border drawn by this view
     /// surrounds the original position of the text:
     ///
     ///     Text("Offset by passing horizontal & vertical distance")
     ///         .border(Color.green)
     ///         .offset(x: 20, y: 50)
     ///         .border(Color.gray)
     ///
     /// ![A screenshot showing a view that offset from its original position
     /// using and x and y offset.](swiftui-offset-xy.png)
     ///
     /// - Parameters:
     ///   - x: The horizontal distance to offset this view.
     ///   - y: The vertical distance to offset this view.
     ///
     /// - Returns: A view that offsets this view by `x` and `y`.
     @inlinable public func offset(x: CGFloat = 0, y: CGFloat = 0) -> some View

 }
 */

func rangeOfRanges<C: Collection>(_ ranges: C) -> Range<Double>
where C.Element == Range<Double> {
    guard !ranges.isEmpty else { return 0..<0 }
    let low = ranges.lazy.map { $0.lowerBound }.min()!
    let high = ranges.lazy.map { $0.upperBound }.max()!
    return low..<high
}

func magnitude(of range: Range<Double>) -> Double {
    range.upperBound - range.lowerBound
}

struct HikeGraph_Previews: PreviewProvider {
    static var hike = ModelData().hikes[0]
    
    static var previews: some View {
        Group {
            HikeGraph(hike: hike, path: \.elevation)
                .frame(height: 200)
            HikeGraph(hike: hike, path: \.heartRate)
                .frame(height: 200)
            HikeGraph(hike: hike, path: \.pace)
                .frame(height: 200)
        }
    }
}
