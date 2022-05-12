/*
 A modifier that you apply to a view or another view modifier, producing a different version of the original value.
 
 Adopt the ViewModifier protocol when you want to create a reusable modifier that you can apply to any view. The example below combines several modifiers to create a new modifier that you can use to create blue caption text surrounded by a rounded rectangle:
 struct BorderedCaption: ViewModifier {
     func body(content: Content) -> some View {
         content
             .font(.caption2)
             .padding(10)
             .overlay(
                 RoundedRectangle(cornerRadius: 15)
                     .stroke(lineWidth: 1)
             )
             .foregroundColor(Color.blue)
     }
 }
 You can apply modifier(_:) directly to a view, but a more common and idiomatic approach uses modifier(_:) to define an extension to View itself that incorporates the view modifier:
 extension View {
     func borderedCaption() -> some View {
         modifier(BorderedCaption())
     }
 }
 You can then apply the bordered caption to any view, similar to this:
 Image(systemName: "bus")
     .resizable()
     .frame(width:50, height:50)
 Text("Downtown Bus")
     .borderedCaption()
 */
public protocol ViewModifier {
    associatedtype Body: View
    typealias Content = _ViewModifier_Content<Self>
    func body(content: Self.Content) -> Self.Body
}

extension ViewModifier where Self.Body == Never {
    public func body(content: Self.Content) -> Self.Body {
        fatalError()
    }
}

extension ViewModifier {
    public func concat<T>(_ modifier: T) -> ModifiedContent<Self, T> {
        return .init(content: self, modifier: modifier)
    }
}

extension ViewModifier {
    static func _makeView(modifier: _GraphValue<Self>, inputs: _ViewInputs, body: @escaping (_Graph, _ViewInputs) -> _ViewOutputs) -> _ViewOutputs {
        fatalError()
    }
    static func _makeViewList(modifier: _GraphValue<Self>, inputs: _ViewListInputs, body: @escaping (_Graph, _ViewListInputs) -> _ViewListOutputs) -> _ViewListOutputs {
        fatalError()
    }
}
