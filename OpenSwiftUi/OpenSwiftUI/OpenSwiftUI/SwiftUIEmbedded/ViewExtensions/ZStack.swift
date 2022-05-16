import OpenSwiftUI

extension ZStack: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        let node = ViewNode(value: ZStackDrawable())
        parent.addChild(node: node)
        
        // CustomView 是不会添加到 ViewTree 里面的, 是 Body 生成的 View 添加到 ViewTree 中
        // 而 Body 生成的 View, 一定是 Primitive View.
        ViewExtractor.extractViews(contents: _tree.content).forEach {
            $0.buildDebugTree(tree: &tree, parent: node)
        }
    }
}
