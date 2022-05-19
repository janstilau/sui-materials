/*
 这个特性中文可以叫动态查找成员。在使用@dynamicMemberLookup标记了对象后（对象、结构体、枚举、protocol），实现了subscript(dynamicMember member: String)方法后我们就可以访问到对象不存在的属性。如果访问到的属性不存在，就会调用到实现的 subscript(dynamicMember member: String)方法，key 作为 member 传入这个方法。
 比如我们声明了一个结构体，没有声明属性。
 */

/*
 /// A property wrapper type that can read and write a value owned by a source of
 /// truth.
 
 /// Use a binding to create a two-way connection between a property that stores
 /// data, and a view that displays and changes the data. A binding connects a
 /// property to a source of truth stored elsewhere, instead of storing data
 /// directly. For example, a button that toggles between play and pause can
 /// create a binding to a property of its parent view using the `Binding`
 /// property wrapper.
 
 ///     struct PlayButton: View {
 ///         @Binding var isPlaying: Bool
 ///
 ///         var body: some View {
 ///             Button(action: {
 ///                 self.isPlaying.toggle()
 ///             }) {
 ///                 Image(systemName: isPlaying ? "pause.circle" : "play.circle")
 ///             }
 ///         }
 ///     }
 
 
 /// The parent view declares a property to hold the playing state, using the
 /// ``State`` property wrapper to indicate that this property is the value's
 /// source of truth.
 ///
 ///     struct PlayerView: View {
 ///         var episode: Episode
 ///         @State private var isPlaying: Bool = false
 ///
 ///         var body: some View {
 ///             VStack {
 ///                 Text(episode.title)
 ///                 Text(episode.showTitle)
 ///                 PlayButton(isPlaying: $isPlaying)
 ///             }
 ///         }
 ///     }
 ///
 /// When `PlayerView` initializes `PlayButton`, it passes a binding of its state
 /// property into the button's binding property. Applying the `$` prefix to a
 /// property wrapped value returns its ``State/projectedValue``, which for a
 /// state property wrapper returns a binding to the value.
 ///
 /// Whenever the user taps the `PlayButton`, the `PlayerView` updates its
 /// `isPlaying` state.
 @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
 @frozen @propertyWrapper @dynamicMemberLookup public struct Binding<Value> {

     /// The binding's transaction.
     ///
     /// The transaction captures the information needed to update the view when
     /// the binding value changes.
     public var transaction: Transaction

     /// Creates a binding with closures that read and write the binding value.
     ///
     /// - Parameters:
     ///   - get: A closure that retrieves the binding value. The closure has no
     ///     parameters, and returns a value.
     ///   - set: A closure that sets the binding value. The closure has the
     ///     following parameter:
     ///       - newValue: The new value of the binding value.
     public init(get: @escaping () -> Value, set: @escaping (Value) -> Void)

     /// Creates a binding with a closure that reads from the binding value, and
     /// a closure that applies a transaction when writing to the binding value.
     ///
     /// - Parameters:
     ///   - get: A closure to retrieve the binding value. The closure has no
     ///     parameters, and returns a value.
     ///   - set: A closure to set the binding value. The closure has the
     ///     following parameters:
     ///       - newValue: The new value of the binding value.
     ///       - transaction: The transaction to apply when setting a new value.
     public init(get: @escaping () -> Value, set: @escaping (Value, Transaction) -> Void)

     /// Creates a binding with an immutable value.
     ///
     /// Use this method to create a binding to a value that cannot change.
     /// This can be useful when using a ``PreviewProvider`` to see how a view
     /// represents different values.
     ///
     ///     // Example of binding to an immutable value.
     ///     PlayButton(isPlaying: Binding.constant(true))
     ///
     /// - Parameter value: An immutable value.
     public static func constant(_ value: Value) -> Binding<Value>

     /// The underlying value referenced by the binding variable.
     ///
     /// This property provides primary access to the value's data. However, you
     /// don't access `wrappedValue` directly. Instead, you use the property
     /// variable created with the `@Binding` attribute. For instance, in the
     /// following code example the binding variable `isPlaying` returns the
     /// value of `wrappedValue`:
     ///
     ///     struct PlayButton: View {
     ///         @Binding var isPlaying: Bool
     ///
     ///         var body: some View {
     ///             Button(action: {
     ///                 self.isPlaying.toggle()
     ///             }) {
     ///                 Image(systemName: isPlaying ? "pause.circle" : "play.circle")
     ///             }
     ///         }
     ///     }
     ///
     /// When a mutable binding value changes, the new value is immediately
     /// available. However, updates to a view displaying the value happens
     /// asynchronously, so the view may not show the change immediately.
     public var wrappedValue: Value { get nonmutating set }

     /// A projection of the binding value that returns a binding.
     ///
     /// Use the projected value to pass a binding value down a view hierarchy.
     /// To get the `projectedValue`, prefix the property variable with `$`. For
     /// example, in the following code example `PlayerView` projects a binding
     /// of the state property `isPlaying` to the `PlayButton` view using
     /// `$isPlaying`.
     ///
     ///     struct PlayerView: View {
     ///         var episode: Episode
     ///         @State private var isPlaying: Bool = false
     ///
     ///         var body: some View {
     ///             VStack {
     ///                 Text(episode.title)
     ///                 Text(episode.showTitle)
     ///                 PlayButton(isPlaying: $isPlaying)
     ///             }
     ///         }
     ///     }
     public var projectedValue: Binding<Value> { get }

     /// Creates a binding from the value of another binding.
     public init(projectedValue: Binding<Value>)

     /// Returns a binding to the resulting value of a given key path.
     ///
     /// - Parameter keyPath: A key path to a specific resulting value.
     ///
     /// - Returns: A new binding.
     public subscript<Subject>(dynamicMember keyPath: WritableKeyPath<Value, Subject>) -> Binding<Subject> { get }
 }
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
        // 感觉这里的实现应该有问题, 应该是调用存储的 Get, Set 属性.
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
