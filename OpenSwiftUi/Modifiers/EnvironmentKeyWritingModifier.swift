public protocol EnvironmentKey {
    associatedtype Value
    static var defaultValue: Self.Value { get }
}

public struct EnvironmentValues: CustomStringConvertible {
    // 使用, Any 来进行通用的存储.
    // 使用, 泛型来进行类型的绑定. 给外界提供好用的接口.
    // 这一切, 都是通过 KeyPath 来实现的. 
    var values: [ObjectIdentifier: Any] = [:]
    
    public init() { }
    
    public subscript<K>(key: K.Type) -> K.Value where K: EnvironmentKey {
        get {
            // 泛型编程的绑定类型的作用, 在这里用的很广.
            if let value = values[ObjectIdentifier(key)] as? K.Value {
                return value
            }
            return K.defaultValue
        }
        set {
            values[ObjectIdentifier(key)] = newValue
        }
    }
    public var description: String {
        get {
            return ""
        }
    }
}

/*
 // Font 是一个可以继承的属性.
 extension View {
     public func font(_ font: Font?) -> some View {
         return environment(\.font, font)
     }
 }

 enum FontEnvironmentKey: EnvironmentKey {
     static var defaultValue: Font? { return nil }
 }

 extension EnvironmentValues {
     public var font: Font? {
         set { self[FontEnvironmentKey.self] = newValue }
         get { self[FontEnvironmentKey.self] }
     }
 }

 */

protocol DynamicProperty { }

@propertyWrapper
public struct Environment<Value>: DynamicProperty {
    internal enum Content {
        case keyPath(KeyPath<EnvironmentValues, Value>)
        case value(Value)
    }
    
    internal var content: Environment<Value>.Content
    public init(_ keyPath: KeyPath<EnvironmentValues, Value>) {
        content = .keyPath(keyPath)
    }
    public var wrappedValue: Value {
        get {
            switch content {
            case let .value(value):
                return value
            case let .keyPath(keyPath):
                return EnvironmentValues()[keyPath: keyPath]
            }
        }
    }
    
    internal func error() -> Never {
        fatalError()
    }
}

public struct _EnvironmentKeyWritingModifier<Value>: ViewModifier {
    public var keyPath: WritableKeyPath<EnvironmentValues, Value>
    public var value: Value
    public init(keyPath: WritableKeyPath<EnvironmentValues, Value>,
                value: Value) {
        self.keyPath = keyPath
        self.value = value
    }
    public typealias Body = Never
}

extension View {
    public func environment<V>(_ keyPath: WritableKeyPath<EnvironmentValues, V>,
                               _ value: V) -> some View {
        return modifier(_EnvironmentKeyWritingModifier(keyPath: keyPath, value: value))
    }
}
