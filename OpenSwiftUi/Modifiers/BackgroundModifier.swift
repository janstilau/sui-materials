// Back Modier 就是收集一个 View, 这个 View 会显示在 ContentView 的后面.
// 可以想象, 在绘制系统里面, 得到 _BackgroundModifier 和 View 组合而成的 ModifiedContent 之后, 先是按照
// _BackgroundModifier 里面存储的 View 绘制到底层上, 然后才是绘制 View 的内容.

/*
 父view为子view提供一个建议的size
 子view根据自身的特性，返回一个size
 父view根据子view返回的size为其进行布局
 */
public struct _BackgroundModifier<Background>: ViewModifier where Background: View {
    public typealias Body = Never
    public typealias Content = View
    
    public let background: Background
    public let alignment: Alignment
    
    init(background: Background, alignment: Alignment) {
        self.background = background
        self.alignment = alignment
    }
}

extension _BackgroundModifier {
    public static func _makeView(modifier: _GraphValue<_BackgroundModifier<Background>>, inputs: _ViewInputs, body: @escaping (_Graph, _ViewInputs) -> _ViewOutputs) -> _ViewOutputs {
        fatalError()
    }
}

extension View {
    public func background<Background>(_ background: Background,
                                       alignment: Alignment = .center) -> some View where Background: View {
        return modifier(
            _BackgroundModifier(background: background,
                                alignment: alignment))
    }
}
