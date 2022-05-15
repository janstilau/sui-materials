

/*
 Drawable 的各种定义, 更多的是位置计算相关的工作. 
 */
public protocol Drawable: CustomDebugStringConvertible {
    var origin: Point { get set }
    var size: Size { get set }
    
    func wantedWidthForProposal(_ proposedWidth: Int, otherLength: Int?) -> Int
    func wantedHeightForProposal(_ proposedHeight: Int, otherLength: Int?) -> Int
    
    var passthrough: Bool { get }
}

extension Drawable {
    public var passthrough: Bool {
        return false
    }
}
