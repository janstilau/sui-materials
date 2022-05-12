import Foundation

/*
 A 2D shape that you can use when drawing a view.
 
 protocol Shape : Animatable, View
 
 Shapes without an explicit fill or stroke get a default fill based on the foreground color.
 You can define shapes in relation to an implicit frame of reference, such as the natural size of the view that contains it. Alternatively, you can define shapes in terms of absolute coordinates.
 */
public protocol Shape: Animatable, View {
    /*
     Shape 就是可以在一个矩形里面, 划出 Path 出来. 
     */
    func path(in rect: CGRect) -> Path
}

extension Shape {
    public var body: _ShapeView<Self, ForegroundStyle> {
        fatalError()
    }
}



public protocol ShapeStyle {
    static func _makeView<S>(view: _GraphValue<_ShapeView<S, Self>>, inputs: _ViewInputs) -> _ViewOutputs where S: Shape
}

extension ShapeStyle where Self: View, Self.Body == _ShapeView<Rectangle, Self> {
    public var body: _ShapeView<Rectangle, Self> {
        get {
            fatalError()
        }
    }
}


public struct FillStyle: Equatable {
    public var isEOFilled: Bool
    public var isAntialiased: Bool
    public init(eoFill: Bool = false, antialiased: Bool = true) {
        self.isEOFilled = eoFill
        self.isAntialiased = antialiased
    }
}



public struct ForegroundStyle {
    public init() {}
}

extension ForegroundStyle: ShapeStyle {
    public static func _makeView<S>(view: _GraphValue<_ShapeView<S, ForegroundStyle>>, inputs: _ViewInputs) -> _ViewOutputs where S : Shape {
        fatalError()
    }
}
