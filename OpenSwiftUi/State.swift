/*
 State
 A property wrapper type that can read and write a value managed by SwiftUI.
 
 Declaration
 @frozen @propertyWrapper struct State<Value>
 Overview
 SwiftUI manages the storage of a property that you declare as state. When the value changes, SwiftUI updates the parts of the view hierarchy that depend on the value. Use state as the single source of truth for a given value stored in a view hierarchy.
 
 A State instance isn’t the value itself; it’s a means of reading and writing the value. To access a state’s underlying value, refer to it by its property name, which returns the wrappedValue property value. For example, you can read and update the isPlaying state property in a PlayButton view by referring to the property directly:
 
 struct PlayButton: View {
 @State private var isPlaying: Bool = false
 
 var body: some View {
 Button(isPlaying ? "Pause" : "Play") {
 isPlaying.toggle()
 }
 }
 }
 If you pass a state property to a child view, SwiftUI updates the child any time the value changes in the parent, but the child can’t modify the value. To enable the child view to modify the stored value, pass a Binding instead. You can get a binding to a state value by accessing the state’s projectedValue, which you get by prefixing the property name with a dollar sign ($).
 
 For example, you can remove the isPlaying state from the play button in the example above, and instead make the button take a binding to the state:
 
 struct PlayButton: View {
 @Binding var isPlaying: Bool
 
 var body: some View {
 Button(isPlaying ? "Pause" : "Play") {
 isPlaying.toggle()
 }
 }
 }
 Then you can define a player view that declares the state and creates a binding to the state using the dollar sign prefix:
 
 struct PlayerView: View {
 var episode: Episode
 @State private var isPlaying: Bool = false
 
 var body: some View {
 VStack {
 Text(episode.title)
 .foregroundStyle(isPlaying ? .primary : .secondary)
 PlayButton(isPlaying: $isPlaying) // Pass a binding.
 }
 }
 }
 Don’t initialize a state property of a view at the point in the view hierarchy where you instantiate the view, because this can conflict with the storage management that SwiftUI provides. To avoid this, always declare state as private, and place it in the highest view in the view hierarchy that needs access to the value. Then share the state with any child views that also need access, either directly for read-only access, or as a binding for read-write access.
 
 You can safely mutate state properties from any thread.
 */

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
    
    /*
     传递出去的, 是一个特殊的对象. 里面存储了 SetGet 方法.
     State 里面, 是应一个引用值, 来存储真正的数据.
     
     Binding 值, 存储的是对于这个引用值的修改.
     这样, 就能保证, 其实操作的是同样的一个值. 
     */
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
