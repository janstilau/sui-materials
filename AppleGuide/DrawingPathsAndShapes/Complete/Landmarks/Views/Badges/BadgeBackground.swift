/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that displays the background of a badge.
*/

import SwiftUI

struct BadgeBackground: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                var width = min(geometry.size.width, geometry.size.height)
                let height = width
                let xScale: CGFloat = 0.832
                let xOffset = (width * (1.0 - xScale)) / 2.0
                width *= xScale

                path.move(
                    to: CGPoint(
                        x: width * 0.95 + xOffset,
                        y: height * (0.20 + HexagonParameters.adjustment)
                    )
                )

                // HexagonParameters.segments 的这个循环, 就是画出整个六边形出来.
                HexagonParameters.segments[0...5].forEach { segment in
                    path.addLine(
                        to: CGPoint(
                            x: width * segment.line.x + xOffset,
                            y: height * segment.line.y
                        )
                    )

                    path.addQuadCurve(
                        to: CGPoint(
                            x: width * segment.curve.x + xOffset,
                            y: height * segment.curve.y
                        ),
                        control: CGPoint(
                            x: width * segment.control.x + xOffset,
                            y: height * segment.control.y
                        )
                    )
                }
            }
            // 上面, 是划出了轮廓.
            .fill(.linearGradient(
                Gradient(colors:
                            [Self.gradientStart, Self.gradientEnd]),
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 0.6)
            ))
            // Fill 是在这个轮廓上, 进行填充.
        }
        /*
         aspectRatio 的展示效果, 使用 ImageView 的 ContentMode 进行思考就好了.
         他更多的是一个 Layout 区域的获取.
         占满 父 Frame, 然后按照 contentMode 来确定子内容的 Frame 的值. 
         */
        // 如果, 不用 aspectRatio 进行修饰, 那么这个背景图会到最顶端. 
        .aspectRatio(1, contentMode: .fit)
    }
    
    /*
     /// Constrains this view's dimensions to the specified aspect ratio.
     
     /// Use `aspectRatio(_:contentMode:)` to constrain a view's dimensions to an
     /// aspect ratio specified by a using the specified
     /// content mode.
     
     /// If this view is resizable, the resulting view will have `aspectRatio` as
     /// its aspect ratio. In this example, the purple ellipse has a 3:4
     /// width-to-height ratio, and scales to fit its frame:
     ///
     ///     Ellipse()
     ///         .fill(Color.purple)
     ///         .aspectRatio(0.75, contentMode: .fit)
     ///         .frame(width: 200, height: 200)
     ///         .border(Color(white: 0.75))
     ///
     /// ![A view showing a purple ellipse that has a 3:4 width-to-height ratio,
     /// and scales to fit its frame.](SwiftUI-View-aspectRatio-cgfloat.png)
     ///
     /// - Parameters:
     ///   - aspectRatio: The ratio of width to height to use for the resulting
     ///     view. Use `nil` to maintain the current aspect ratio in the
     ///     resulting view.
     ///   - contentMode: A flag that indicates whether this view fits or fills
     ///     the parent context.
     ///
     /// - Returns: A view that constrains this view's dimensions to the aspect
     ///   ratio of the given size using `contentMode` as its scaling algorithm.
     */
    
    // 将, 常量定义成为类型量, 然后通过 Self 进行引用.
    static let gradientStart = Color(red: 239.0 / 255, green: 120.0 / 255, blue: 221.0 / 255)
    static let gradientEnd = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255)
}

struct BadgeBackground_Previews: PreviewProvider {
    static var previews: some View {
        BadgeBackground()
    }
}
