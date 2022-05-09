
import Foundation
import UIKit

extension UIColor {
    convenience init(rgbStruct rgb: RGB) {
        let red = CGFloat(rgb.red) / 255.0
        let green = CGFloat(rgb.green) / 255.0
        let blue = CGFloat(rgb.blue) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

struct RGB {
    var red = 127
    var green = 127
    var blue = 127
    
    func difference(target: RGB) -> Double {
        let rDiff = Double(red - target.red)
        let gDiff = Double(green - target.green)
        let bDiff = Double(blue - target.blue)
        return sqrt((rDiff * rDiff + gDiff * gDiff + bDiff * bDiff) / 3.0) / 255.0
    }
    
    static func random() -> RGB {
        var rgb = RGB()
        rgb.red = Int.random(in: 0..<256)
        rgb.green = Int.random(in: 0..<256)
        rgb.blue = Int.random(in: 0..<256)
        return rgb
    }
}
