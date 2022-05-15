/*
 ForEach 其实更多的是一个存储类型.
 将, 可以遍历的 Model 存储起来.
 将如何根据 Item 创建出 View 的逻辑存储起来. 真正起作用, 是在建立 ViewTree 的时候. 
 */
public struct ForEach<Data, ID, Content> where Data: RandomAccessCollection, ID: Hashable {
    public var data: Data
    public var content: (Data.Element) -> Content
}

extension ForEach: View where Content: View {
    public var body: Never {
        fatalError()
    }
    
    public typealias Body = Never
    public static func _makeView(view: _GraphValue<ForEach<Data, ID, Content>>, inputs: _ViewInputs) -> _ViewOutputs {
        fatalError()
    }
    public static func _makeViewList(view: _GraphValue<ForEach<Data, ID, Content>>, inputs: _ViewListInputs) -> _ViewListOutputs {
        fatalError()
    }
}

extension ForEach where ID == Data.Element.ID, Content: View, Data.Element: Identifiable {
    public init(_ data: Data, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
    }
}

extension ForEach where Content: View {
    public init(_ data: Data, id: KeyPath<Data.Element, ID>, content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
    }
}

extension ForEach where Data == Range<Int>, ID == Int, Content: View {
    public init(_ data: Range<Int>, @ViewBuilder content: @escaping (Int) -> Content) {
        self.data = data
        self.content = content
    }
}
