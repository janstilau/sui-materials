import Foundation

// 就是, 将 String 从值语义, 变为引用语义
public class AnyTextStorage<Storage: StringProtocol> {
    public var storage: Storage
    
    internal init(storage: Storage) {
        self.storage = storage
    }
}

public class AnyTextModifier {
    init() { }
}

public struct Text: View, Equatable {
    public typealias Body = Never
    
    public var _storage: Storage
    // 里面, 存储的是 Enum 这种数据类型. 数组里面的 Item 的大小, 是固定的. 是 Enum 中最大数据类型宽度. 
    public var _modifiers: [Text.Modifier] = [Modifier]()
    
    public enum Storage: Equatable {
        public static func == (lhs: Text.Storage, rhs: Text.Storage) -> Bool {
            switch (lhs, rhs) {
            case (.verbatim(let contentA), .verbatim(let contentB)):
                return contentA == contentB
            case (.anyTextStorage(let contentA), .anyTextStorage(let contentB)):
                return contentA.storage == contentB.storage
            default:
                return false
            }
        }
        
        // 一字不差地，逐字地
        case verbatim(String)
        case anyTextStorage(AnyTextStorage<String>)
    }
    
    public enum Modifier: Equatable {
        case color(Color?)
        case font(Font?)
        // case italic
        // case weight(Font.Weight?)
        // case kerning(CGFloat)
        // case tracking(CGFloat)
        // case baseline(CGFloat)
        // case rounded
        // case anyTextModifier(AnyTextModifier)
        public static func == (lhs: Text.Modifier, rhs: Text.Modifier) -> Bool {
            switch (lhs, rhs) {
            case (.color(let colorA), .color(let colorB)):
                return colorA == colorB
            case (.font(let fontA), .font(let fontB)):
                return fontA == fontB
            default:
                return false
            }
        }
    }
    
    public init(verbatim content: String) {
        self._storage = .verbatim(content)
    }
    
    // 其实, 大部分情况下, 变为引用语义值进行存储, 是一个简便的处理方案.
    // 为了一点效率, 让代码复杂, 这样不好.
    public init<S>(_ content: S) where S: StringProtocol {
        self._storage = .anyTextStorage(AnyTextStorage<String>(storage: String(content)))
    }
    
    public init(_ key: LocalizedStringKey, tableName: String? = nil, bundle: Bundle? = nil, comment: StaticString? = nil) {
        self._storage = .anyTextStorage(AnyTextStorage<String>(storage: key.key))
    }
    
    private init(verbatim content: String, modifiers: [Modifier] = []) {
        self._storage = .verbatim(content)
        self._modifiers = modifiers
    }
    
    public static func == (lhs: Text, rhs: Text) -> Bool {
        return lhs._storage == rhs._storage && lhs._modifiers == rhs._modifiers
    }
}

extension Text {
    public func foregroundColor(_ color: Color?) -> Text {
        textWithModifier(Text.Modifier.color(color))
    }
    
    public func font(_ font: Font?) -> Text {
        textWithModifier(Text.Modifier.font(font))
    }
    
    private func textWithModifier(_ modifier: Modifier) -> Text {
        // 所有的 Modifier, 都进行了存储.
        // 虽然产生了一个新的 Text, 但是由于 Text 的数据都是引用数据类型, 所以实际上, 和 Self 进行修改, 没有任何的区别.
        let modifiers = _modifiers + [modifier]
        switch _storage {
        case .verbatim(let content):
            return Text(verbatim: content, modifiers: modifiers)
        case .anyTextStorage(let content):
            return Text(verbatim: content.storage, modifiers: modifiers)
        }
    }
}

extension Text {
    public var body: Never {
        fatalError()
    }
}

extension Text {
    public static func _makeView(view: _GraphValue<Text>, inputs: _ViewInputs) -> _ViewOutputs {
        fatalError()
    }
}
