import OpenSwiftUI

/*
 最终,  ViewTree 里面存储的是 存储了 Drawable 的各种 Node 节点.
 而各种 DrawAble 中, 是复制了 View 中的各种属性的.
 ViewTree 整个是 Model 的 View 表现.
 
 Body 生成的 Primitive View, 会一直存在 ViewTree 中, 被 DrawAble 引用. View 作为 Primitive View 的生成器, 用完就扔了. 
 */
public struct SpacerDrawable: Drawable {
    public var origin: Point = Point.zero
    public var size: Size = Size.zero
    
    public init() { }
    
    public func wantedWidthForProposal(_ proposedWidth: Int, otherLength: Int? = nil) -> Int {
        return proposedWidth
    }
    
    public func wantedHeightForProposal(_ proposedHeight: Int, otherLength: Int? = nil) -> Int {
        return proposedHeight
    }
}

extension SpacerDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Spacer [\(size)]"
    }
}
