
// View 的 modeifer, 其实就是创建一个新的 ModifiedContent 对象.
// 各种 View 的 modifier 方法, 就是在里面, 生成对应的 Modifer 对象, 然后生成 ModifiedContent 对象.
// 所以, 在 SwiftUI 里面, View 的真实含义, 其实是数据收集器.
extension View {
    public func modifier<T>(_ modifier: T) -> ModifiedContent<Self, T> {
        return .init(content: self, modifier: modifier)
    }
}

public struct ModifiedContent<Content, Modifier> {
    public var content: Content
    public var modifier: Modifier
    public init(content: Content, modifier: Modifier) {
        self.content = content
        self.modifier = modifier
    }
}

extension ModifiedContent: View where Content: View, Modifier: ViewModifier {
    public typealias Body = Never
    // 为什么是 Never 呢, 不应该是 self.modifier.body(self.content) 吗
    public var body: ModifiedContent<Content, Modifier>.Body {
        fatalError()
    }
}



extension ModifiedContent {
    public static func _makeView(view: _GraphValue<ModifiedContent<Content, Modifier>>, inputs: _ViewInputs) -> _ViewOutputs {
        fatalError()
    }
    public static func _makeViewList(view: _GraphValue<ModifiedContent<Content, Modifier>>, inputs: _ViewListInputs) -> _ViewListOutputs {
        fatalError()
    }
}

extension ModifiedContent: ViewModifier where Content: ViewModifier, Modifier: ViewModifier {
    public static func _makeView(modifier: _GraphValue<ModifiedContent<Content, Modifier>>, inputs: _ViewInputs, body: @escaping (_Graph, _ViewInputs) -> _ViewOutputs) -> _ViewOutputs {
        fatalError()
    }
    public static func _makeViewList(modifier: _GraphValue<ModifiedContent<Content, Modifier>>, inputs: _ViewListInputs, body: @escaping (_Graph, _ViewListInputs) -> _ViewListOutputs) -> _ViewListOutputs {
        fatalError()
    }
}
