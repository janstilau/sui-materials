public struct TupleView<T>: View {
    
    // Value 可能会是一个 Tuple 类型.
    /*
     public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> TupleView<(C0, C1, C2, C3, C4, C5, C6, C7, C8)> where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View {
         return .init((c0, c1, c2, c3, c4, c5, c6, c7, c8))
     }
     */
    public var value: T
    public typealias Body = Never
    
    public init(_ value: T) {
        self.value = value
    }
}

extension TupleView {
    public var body: Never {
        fatalError()
    }
}

extension TupleView {
    public static func _makeView(view: _GraphValue<TupleView<T>>, inputs: _ViewInputs) -> _ViewOutputs {
        fatalError()
    }
    
    public static func _makeViewList(view: _GraphValue<TupleView<T>>, inputs: _ViewListInputs) -> _ViewListOutputs {
        fatalError()
    }
}
