import Foundation

// 其实, 就是创建一个 Path, 然后使用 Path 的各种 API 来形成 Rectangle 的显示.
public struct Rectangle: Shape {
    public func path(in rect: CGRect) -> Path {
        fatalError()
    }
    public init() {}
    public typealias Body = _ShapeView<Rectangle, ForegroundStyle>
}
