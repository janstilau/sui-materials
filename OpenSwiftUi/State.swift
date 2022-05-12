internal class AnyLocationBase { }

/*
 如果, 传递进来的是一个 Struct 值, 那么这里就是复制的操作.
 如果, Struct 里面含有一个指针, 或者 Value 就是一个引用类型, 那么 Swift 语言, 自动进行引用技术的管理.
 */
internal class AnyLocation<Value>: AnyLocationBase {
    internal let _value = UnsafeMutablePointer<Value>.allocate(capacity: 1)
    init(value: Value) {
        self._value.pointee = value
    }
}

public struct _DynamicPropertyBuffer {
}


/*
 SwiftUI manages the storage of any property you declare as a state.
 When the state value changes, the view invalidates its appearance and recomputes the body.
 Use the state as the single source of truth for a given view.
 
 A State instance isn’t the value itself; it’s a means of reading and writing the value.
 To access a state’s underlying value, use its variable name, which returns the wrappedValue property value.
 
 You should only access a state property from inside the view’s body, or from methods called by it.
 For this reason, declare your state properties as private, to prevent clients of your view from accessing them.
 It is safe to mutate state properties from any thread.
 
 To pass a state property to another view in the view hierarchy, use the variable name with the $ prefix operator.
 This retrieves a binding of the state property from its projectedValue property.
 */
@propertyWrapper
public struct State<Value>: DynamicProperty {
    // 感觉这个 _Value 不应该存在啊, State 作为 propertyWrapper 就是想要把存储成为一个引用值.
    internal var _value: Value
    internal var _location: AnyLocation<Value>?
    
    // 初始化的话, 就是进行 _Location 的创建.
    public init(wrappedValue value: Value) {
        self._value = value
        self._location = AnyLocation(value: value)
    }
    
    public init(initialValue value: Value) {
        self._value = value
        self._location = AnyLocation(value: value)
    }
    
    public var wrappedValue: Value {
        get { return _location?._value.pointee ?? _value }
        nonmutating set { _location?._value.pointee = newValue }
    }
    
    public var projectedValue: Binding<Value> {
        return Binding(get: { return self.wrappedValue },
                       set: { newValue in self.wrappedValue = newValue })
    }
    
    public static func _makeProperty<V>(in buffer: inout _DynamicPropertyBuffer,
                                        container: _GraphValue<V>,
                                        fieldOffset: Int,
                                        inputs: inout _GraphInputs) {
        fatalError()
    }
}

extension State where Value: ExpressibleByNilLiteral {
    public init() {
        self.init(wrappedValue: nil)
    }
}
