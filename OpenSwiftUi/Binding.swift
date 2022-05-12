/*
 这个特性中文可以叫动态查找成员。在使用@dynamicMemberLookup标记了对象后（对象、结构体、枚举、protocol），实现了subscript(dynamicMember member: String)方法后我们就可以访问到对象不存在的属性。如果访问到的属性不存在，就会调用到实现的 subscript(dynamicMember member: String)方法，key 作为 member 传入这个方法。
 比如我们声明了一个结构体，没有声明属性。
 */


/*
 Use a binding to create a two-way connection between a property that stores data, and a view that displays and changes the data.
 A binding connects a property to a source of truth stored elsewhere, instead of storing data directly.
 
 For example, a button that toggles between play and pause can create a binding to a property of its parent view using the Binding property wrapper.
 struct PlayButton: View {
 @Binding var isPlaying: Bool
 
 var body: some View {
 Button(action: {
 self.isPlaying.toggle()
 }) {
 Image(systemName: isPlaying ? "pause.circle" : "play.circle")
 }
 }
 }
 The parent view declares a property to hold the playing state, using the State property wrapper to indicate that this property is the value’s source of truth.
 struct PlayerView: View {
 var episode: Episode
 @State private var isPlaying: Bool = false
 
 var body: some View {
 VStack {
 Text(episode.title)
 Text(episode.showTitle)
 PlayButton(isPlaying: $isPlaying)
 }
 }
 }
 When PlayerView initializes PlayButton, it passes a binding of its state property into the button’s binding property. Applying the $ prefix to a property wrapped value returns its projectedValue, which for a state property wrapper returns a binding to the value.
 Whenever the user taps the PlayButton, the PlayerView updates its isPlaying state.
 */

@propertyWrapper
@dynamicMemberLookup
public struct Binding<Value> {
    public var transaction: Transaction
    internal var location: AnyLocation<Value>
    fileprivate var _value: Value 
    
    public init(get: @escaping () -> Value,
                set: @escaping (Value) -> Void) {
        self.transaction = Transaction()
        self.location = AnyLocation(value: get())
        self._value = get()
        set(_value)
    }
    
    public init(get: @escaping () -> Value,
                set: @escaping (Value, Transaction) -> Void) {
        self.transaction = Transaction()
        self.location = AnyLocation(value: get())
        self._value = get()
        set(_value, self.transaction)
    }
    
    public static func constant(_ value: Value) -> Binding<Value> {
        fatalError()
    }
    
    public var wrappedValue: Value {
        get { return location._value.pointee }
        nonmutating set { location._value.pointee = newValue }
    }
    
    public var projectedValue: Binding<Value> {
        self
    }
    
    public subscript<Subject>(dynamicMember keyPath: WritableKeyPath<Value, Subject>) -> Binding<Subject> {
        fatalError()
    }
}

class StoredLocation<Value>: AnyLocation<Value> {
    
}

extension Binding {
    public func transaction(_ transaction: Transaction) -> Binding<Value> {
        fatalError()
    }
    
    //    public func animation(_ animation: Animation? = .default) -> Binding<Value> {
    //
    //    }
}

extension Binding: DynamicProperty {
    public static func _makeProperty<V>(in buffer: inout _DynamicPropertyBuffer, container: _GraphValue<V>, fieldOffset: Int, inputs: inout _GraphInputs) {
        
    }
}

extension Binding {
    public init<V>(_ base: Binding<V>) where Value == V? {
        fatalError()
    }
    
    public init?(_ base: Binding<Value?>) {
        fatalError()
    }
    
    public init<V>(_ base: Binding<V>) where Value == AnyHashable, V : Hashable {
        fatalError()
    }
}
