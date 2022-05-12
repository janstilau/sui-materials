public enum _VariadicView {
    public typealias Root = _VariadicView_Root
    public typealias ViewRoot = _VariadicView_ViewRoot
    public typealias Children = _VariadicView_Children
    public typealias UnaryViewRoot = _VariadicView_UnaryViewRoot
    public typealias MultiViewRoot = _VariadicView_MultiViewRoot
    
    // 这还是一个值语义的对象, 最主要的就是存值. 
    public struct Tree<Root, Content> where Root: _VariadicView_Root {
        // Root 应该改为 ContentConfig.
        public var root: Root
        public var content: Content
        internal init(root: Root, content: Content) {
            self.root = root
            self.content = content
        }
        public init(_ root: Root, @ViewBuilder content: () -> Content) {
            self.root = root
            self.content = content()
        }
    }
}

extension _VariadicView.Tree: View where Root: _VariadicView_ViewRoot, Content: View {
    public var body: Never {
        fatalError()
    }
    
    public typealias Body = Never
    public static func _makeView(view: _GraphValue<_VariadicView.Tree<Root, Content>>, inputs: _ViewInputs) -> _ViewOutputs {
        fatalError()
    }
    public static func _makeViewList(view: _GraphValue<_VariadicView.Tree<Root, Content>>, inputs: _ViewListInputs) -> _ViewListOutputs {
        fatalError()
    }
}

