import Foundation

/*
 这个程序的核心类. 一个 Model 类.
 就是 RGB 的数据封装.
 提供了 Model 层的 diff 逻辑.
 */
struct RGB {
    var red = 0.5
    var green = 0.5
    var blue = 0.5
    
    /// Compute the normalized 3-dimensional distance to another RGB object.
    ///   - parameters:
    ///     - target: The other RGB object.
    func difference(target: RGB) -> Double {
        let rDiff = red - target.red
        let gDiff = green - target.green
        let bDiff = blue - target.blue
        return sqrt(
            (rDiff * rDiff + gDiff * gDiff + bDiff * bDiff) / 3.0)
    }
    
    /// Create a String representing the integer values of an RGB object.
    func intString() -> String {
        "R: \(Int(red * 255.0))"
        + "  G: \(Int(green * 255.0))"
        + "  B: \(Int(blue * 255.0))"
    }
}

extension RGB {
    /// Create an RGB object with random values.
    static func random() -> RGB {
        var rgb = RGB()
        rgb.red = Double.random(in: 0..<1)
        rgb.green = Double.random(in: 0..<1)
        rgb.blue = Double.random(in: 0..<1)
        return rgb
    }
}
