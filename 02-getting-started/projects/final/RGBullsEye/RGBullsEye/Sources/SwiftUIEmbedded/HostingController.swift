
import Pixels
import Foundation
#if canImport(AppKit)
import AppKit
#endif

public struct Interaction {
    public var frame: CGRect
    public var action: () -> Void
}

public class HostingController<Content: View> {
    public typealias ColorDepth = UInt32
    public typealias ColorDepthProtocol = FixedWidthInteger & UnsignedInteger
    
    public var tree: ViewNode
    
    public var interactiveAreas = [Interaction]()
    
    private var canvas: Pixels<ColorDepth>
    private var rootView: Content
    private var debugViews: Bool
    
    public init(rootView: Content, width: Int = 320, height: Int = 240, debugViews: Bool = false) {
        self.canvas = Pixels<ColorDepth>(width: width, height: height, canvasColor: ColorDepth.max)
        self.rootView = rootView
        self.tree = ViewNode(value: RootDrawable())
        self.debugViews = debugViews
    }
    
    private func calculateTreeSizes() {
        let width = canvas.canvasWidth
        let height = canvas.canvasHeight
        let displaySize = Size(width: width, height: height)
        tree.calculateSize(givenWidth: width, givenHeight: height)
        tree.value.size = displaySize
    }
    
    /*
     递归绘制, 树上所有的节点.
     Drawable 没有把所有的绘制相关的责任, 划分到自己的内部.
     而是在 Draw 方法里面, 进行了类型判断.
     */
    /*
     这是一个通用的模式, 将渲染树的内容, 绘制出来.
     */
    private func drawNodesRecursively(node: ViewNode) {
        guard node.value.size.width > 0 else { return }
        
        let parentPadding = (node.parent?.value as? ModifiedContentDrawable<PaddingModifier>)?.modifier.value ?? EdgeInsets()
        
        /*
         许多属性, 之所以会有继承的概念, 是在 NodeTree 中, 可以不断的进行向上寻找.
         */
        var foregroundColor: Color?
        for ancestor in node.ancestors {
            if let color = (ancestor.value as? ModifiedContentDrawable<_EnvironmentKeyWritingModifier<Color?>>)?.modifier.value {
                foregroundColor = color
                break
            }
        }
        
        var colorScheme: ColorScheme = .light
        for ancestor in node.ancestors {
            if let scheme = (ancestor.value as? ModifiedContentDrawable<_EnvironmentKeyWritingModifier<ColorScheme>>)?.modifier.value {
                colorScheme = scheme
                break
            }
        }
        
        let width = node.value.size.width
        let height = node.value.size.height
        
        // 当前, ViewNode 的位置, 是父 View 的递归偏移 + 当前 Node 的 x + Padding 的位置.
        let originX = node.ancestors.reduce(0, { $0 + $1.value.origin.x }) +
        node.value.origin.x +
        Int(parentPadding.leading)
        let originY = node.ancestors.reduce(0, { $0 + $1.value.origin.y }) +
        node.value.origin.y +
        Int(parentPadding.top)
        
        if let colorNode = node.value as? ColorDrawable {
            let color = canvas.unsignedIntegerFromColor(colorNode.color)
            canvas.drawBox(x: originX,
                           y: originY,
                           width: width,
                           height: height,
                           color: color,
                           dotted: false,
                           brushSize: 1,
                           filled: true)
        }
        
        if let backgroundNode = node.value as? ModifiedContentDrawable<_BackgroundModifier<Color>> {
            let color = canvas.unsignedIntegerFromColor(backgroundNode.modifier.background, colorScheme: colorScheme)
            canvas.drawBox(x: originX,
                           y: originY,
                           width: width,
                           height: height,
                           color: color,
                           dotted: false,
                           brushSize: 1,
                           filled: true)
        }
        
        if let textNode = node.value as? TextDrawable {
            var textColor = Color.primary
            for modifier in textNode.modifiers {
                switch modifier {
                case .color(let color):
                    if let color = color {
                        textColor = color
                    }
                default: continue
                }
            }
            
            let color = canvas.unsignedIntegerFromColor(textColor, colorScheme: colorScheme)
            canvas.drawBitmapText(text: textNode.text,
                                  x: originX,
                                  y: originY,
                                  width: width,
                                  height: height,
                                  alignment: .left,
                                  color: color,
                                  // 这里有点问题, 其实是如果 textNode 找不到自身的 Font 属性, 应该顺着向上找父节点的 Font 属性.
                                  // 如果都没有, 才使用默认的 Font.Body.
                                  font: textNode.resolvedFont.font)
        }
        
        if let imageNode = node.value as? ImageDrawable {
            let color = canvas.unsignedIntegerFromColor(foregroundColor ?? Color.primary)
            canvas.drawBitmap(bytes: imageNode.bitmap.bytes,
                              x: originX,
                              y: originY,
                              width: imageNode.bitmap.size.width,
                              height: imageNode.bitmap.size.height,
                              color: color)
        }
        
        // 这里的实现, 有点问题, 应该是 ShapeDrawable, 得到 Path 之后, 然后使用 Path 进行绘制.
        // Rectangle 和 Circle 其实都是 Path 的一种常用 case 而已.
        if let _ = node.value as? CircleDrawable {
            let color = canvas.unsignedIntegerFromColor(foregroundColor ?? Color.primary)
            let diameter = min(width, height)
            let radius = diameter / 2
            var offsetX = 0
            if width > diameter {
                offsetX = (width - diameter) / 2
            }
            var offsetY = 0
            if height > diameter {
                offsetY = (height - diameter) / 2
            }
            canvas.drawCircle(xm: originX + radius + offsetX, ym: originY + radius + offsetY, radius: radius, color: color)
        }
        
        if let _ = node.value as? RectangleDrawable {
            let color = canvas.unsignedIntegerFromColor(foregroundColor ?? Color.primary)
            canvas.drawBox(x: originX, y: originY, width: width, height: height, color: color, filled: true)
        }
        
        if let _ = node.value as? DividerDrawable {
            let color = canvas.unsignedIntegerFromColor(foregroundColor ?? Color.gray)
            canvas.drawBox(x: originX, y: originY, width: width, height: height, color: color, filled: true)
        }
        
        if let button = node.value as? ButtonDrawable {
            let frame = CGRect(x: originX, y: originY, width: width, height: height)
            let action = Interaction(frame: frame, action: button.action)
            interactiveAreas.append(action)
        }
        
        if debugViews {
            canvas.drawBox(x: originX,
                           y: originY,
                           width: width,
                           height: height,
                           color: canvas.unsignedIntegerFromColor(Color.purple),
                           dotted: true,
                           brushSize: 1)
        }
        
        if node.isBranch {
            for child in node.children {
                drawNodesRecursively(node: child)
            }
        }
    }
    
    public func redrawnCanvas() -> Pixels<ColorDepth> {
        canvas.clear()
        
        self.tree = ViewNode(value: RootDrawable())
        
        /*
         rootView.body 返回的是一个 ViewTree. buildDebugTree 所要做的, 就是将 ViewTree 变为 NodeTree.
         而 NodeTree 中会计算出各个节点数据的真正位置, 进行 Layout 处理.
         在 drawNodesRecursively 里面, 会根据各个 View, 在对应的位置, 进行真正的 Draw 的动作.
         */
        (rootView.body as? ViewBuildable)?.buildDebugTree(tree: &tree, parent: tree)
        
        calculateTreeSizes()
        drawNodesRecursively(node: tree)
        return canvas
    }
    
#if canImport(AppKit)
    public func createPixelBufferImage() -> NSImage? {
        return redrawnCanvas().image()
    }
#endif
    
    public func createPixelBuffer() -> [ColorDepth] {
        return redrawnCanvas().bytes
    }
}
