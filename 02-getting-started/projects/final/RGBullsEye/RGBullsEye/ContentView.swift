
import SwiftUI

/*
 MVVM 中, VC 的责任是构建 View, 以及 ViewAction 对于 ModelAction 的触发, Model 的信号和 View 的绑定.
 这些, 在 SwiftUI 中, 使用 Body 函数就能搞定了.
 
 所以, 在 Body 中, 其实就是做的上面的三件事.
 */


/*
 
 /// A color or pattern to use when rendering a shape.
 
 /// You don't use the `ShapeStyle` protocol directly. Instead, use one of
 /// the concrete styles that SwiftUI defines. To indicate a specific color
 /// or pattern, you can use ``Color`` or the style returned by
 /// ``ShapeStyle/image(_:sourceRect:scale:)``, or one of the gradient
 /// types, like the one returned by
 /// ``ShapeStyle/radialGradient(_:center:startRadius:endRadius:)``.
 /// To set a color that's appropriate for a given context on a given
 /// platform, use one of the semantic styles, like ``ShapeStyle/background`` or
 /// ``ShapeStyle/primary``.
 ///
 /// You can use a shape style by:
 /// * Filling a shape with a style with the ``Shape/fill(_:style:)`` modifier:
 ///
 ///     ```
 ///     Path { path in
 ///         path.move(to: .zero)
 ///         path.addLine(to: CGPoint(x: 50, y: 0))
 ///         path.addArc(
 ///             center: .zero,
 ///             radius: 50,
 ///             startAngle: .zero,
 ///             endAngle: .degrees(90),
 ///             clockwise: false)
 ///     }
 ///     .fill(.radial(
 ///         Gradient(colors: [.yellow, .red]),
 ///         center: .topLeading,
 ///         startRadius: 15,
 ///         endRadius: 80))
 ///     ```
 ///
 ///     ![A screenshot of a quarter of a circle filled with
 ///     a radial gradient.](ShapeStyle-1)
 ///
 /// * Tracing the outline of a shape with a style with either the
 ///   ``Shape/stroke(_:lineWidth:)`` or the ``Shape/stroke(_:style:)`` modifier:
 ///
 ///     ```
 ///     RoundedRectangle(cornerRadius: 10)
 ///         .stroke(.mint, lineWidth: 10)
 ///         .frame(width: 200, height: 50)
 ///     ```
 ///
 ///     ![A screenshot of a rounded rectangle, outlined in mint.](ShapeStyle-2)
 ///
 /// * Styling the foreground elements in a view with the
 ///   ``View/foregroundStyle(_:)`` modifier:
 ///
 ///     ```
 ///     VStack(alignment: .leading) {
 ///         Text("Primary")
 ///             .font(.title)
 ///         Text("Secondary")
 ///             .font(.caption)
 ///             .foregroundStyle(.secondary)
 ///     }
 ///     ```
 ///
 ///     ![A screenshot of a title in the primary content color above a
 ///     subtitle in the secondary content color.](ShapeStyle-3)
 @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
 public protocol ShapeStyle { }

 
 和 Font 一样, 不同的类型, 来完成同样的操作.
 一个通用数据类型做参数, 在真正使用的时候, 一定会有 dispatch 的过程.
 */
struct ContentView: View {
    // ViewModel
    @State var gameController = Game()
    // ViewStateModel
    @State var guess: RGB
    // ViewStateModel
    @State var showScore = false
    
    var body: some View {
        
        VStack {
            Circle()
                .fill(Color(rgbStruct: gameController.target))
            if !showScore {
                Text("R: ??? G: ??? B: ???")
                    .padding()
            } else {
                Text(gameController.target.intString())
            }
            Circle()
                .fill(Color(rgbStruct: guess))
            Text(guess.intString())
                .padding()
            // @State 里面的 red, 并不是一个 @State 的值, 也可以当做是 Subject 来进行 使用了.
            ColorSlider(value: $guess.red, trackColor: .red)
            ColorSlider(value: $guess.green, trackColor: .green)
            ColorSlider(value: $guess.blue, trackColor: .blue)
            Button("Hit Me!") {
                showScore = true
                gameController.check(guess: guess)
            }
            /*
             public func alert(isPresented: Binding<Bool>, content: () -> Alert) -> some View
             */
            .alert(isPresented: $showScore) {
                Alert(
                    title: Text("Your Score"),
                    message: Text(String(gameController.scoreInCurrentRound)),
                    dismissButton: .default(Text("OK")) {
                        gameController.startNewRound()
                        guess = RGB()
                    })
            }
        }
    }
}

/*
 extension View {
     /// Presents an alert to the user.
     ///
     /// Use this method when you need to show an alert that contains
     /// information from a binding to an optional data source that you provide.
     /// The example below shows a custom data source `FileInfo` whose
     /// properties configure the alert's `message` field:
     
     ///     struct FileInfo: Identifiable {
     ///         var id: String { name }
     ///         let name: String
     ///         let fileType: UTType
     ///     }
     
     ///     struct ConfirmImportAlert: View {
     ///         @State var alertDetails: FileInfo?
     ///         var body: some View {
     ///             Button("Show Alert") {
     ///                 alertDetails = FileInfo(name: "MyImageFile.png",
     ///                                         fileType: .png)
     ///             }
     ///             .alert(item: $alertDetails) { details in
     ///                 Alert(title: Text("Import Complete"),
     ///                       message: Text("""
     ///                         Imported \(details.name) \n File
     ///                         type: \(details.fileType.description).
     ///                         """),
     ///                       dismissButton: .default(Text("Dismiss")))
     ///             }
     ///         }
     ///     }
     ///
     
     /// ![An alert showing information from a data source that describes the
     /// result of a file import process. The alert displays the name of the
     /// file imported, MyImageFile.png and its file type, the PNG image
     /// file format along with a default OK button for dismissing the
     /// alert.](SwiftUI-View-AlertItemContent.png)
     
     /// - Parameters:
     ///   - item: A binding to an optional source of truth for the alert.
     ///     if `item` is non-`nil`, the system passes the contents to
     ///     the modifier's closure. You use this content to populate the fields
     ///     of an alert that you create that the system displays to the user.
     ///     If `item` changes, the system dismisses the currently displayed
     ///     alert and replaces it with a new one using the same process.
     ///   - content: A closure returning the alert to present.
     public func alert<Item>(item: Binding<Item?>, content: (Item) -> Alert) -> some View where Item : Identifiable


     /// Presents an alert to the user.
     ///
     /// Use this method when you need to show an alert to the user. The example
     /// below displays an alert that is shown when the user toggles a
     /// Boolean value that controls the presentation of the alert:
     ///
     ///     struct OrderCompleteAlert: View {
     ///         @State private var isPresented = false
     ///         var body: some View {
     ///             Button("Show Alert", action: {
     ///                 isPresented = true
     ///             })
     ///             .alert(isPresented: $isPresented) {
     ///                 Alert(title: Text("Order Complete"),
     ///                       message: Text("Thank you for shopping with us."),
     ///                       dismissButton: .default(Text("OK")))
     ///             }
     ///         }
     ///     }
     ///
     /// ![An alert whose title reads Order Complete, with the
     /// message, Thank you for shopping with us placed underneath. The alert
     /// also includes an OK button for dismissing the
     /// alert.](SwiftUI-View-AlertIsPresentedContent.png)
     /// - Parameters:
     ///   - isPresented: A binding to a Boolean value that determines whether
     ///     to present the alert that you create in the modifier's `content` closure. When the
     ///      user presses or taps OK the system sets `isPresented` to `false`
     ///     which dismisses the alert.
     ///   - content: A closure returning the alert to present.
     public func alert(isPresented: Binding<Bool>, content: () -> Alert) -> some View
 }
 
 public struct Alert {
     /// Creates an alert with one button.
     /// - Parameters:
     ///   - title: The title of the alert.
     ///   - message: The message to display in the body of the alert.
     ///   - dismissButton: The button that dismisses the alert.
     public init(title: Text, message: Text? = nil, dismissButton: Alert.Button? = nil)

     /// Creates an alert with two buttons.
     ///
     /// The system determines the visual ordering of the buttons.
     /// - Parameters:
     ///   - title: The title of the alert.
     ///   - message: The message to display in the body of the alert.
     ///   - primaryButton: The first button to show in the alert.
     ///   - secondaryButton: The second button to show in the alert.
     public init(title: Text, message: Text? = nil, primaryButton: Alert.Button, secondaryButton: Alert.Button)

     /// A button representing an operation of an alert presentation.
     public struct Button {

         /// Creates an alert button with the default style.
         /// - Parameters:
         ///   - label: The text to display on the button.
         ///   - action: A closure to execute when the user taps or presses the
         ///   button.
         /// - Returns: An alert button with the default style.
         public static func `default`(_ label: Text, action: (() -> Void)? = {}) -> Alert.Button

         /// Creates an alert button that indicates cancellation, with a custom
         /// label.
         /// - Parameters:
         ///   - label: The text to display on the button.
         ///   - action: A closure to execute when the user taps or presses the
         ///   button.
         /// - Returns: An alert button that indicates cancellation.
         public static func cancel(_ label: Text, action: (() -> Void)? = {}) -> Alert.Button

         /// Creates an alert button that indicates cancellation, with a
         /// system-provided label.
         ///
         /// The system automatically chooses locale-appropriate text for the
         /// button's label.
         /// - Parameter action: A closure to execute when the user taps or presses the
         ///   button.
         /// - Returns: An alert button that indicates cancellation.
         public static func cancel(_ action: (() -> Void)? = {}) -> Alert.Button

         /// Creates an alert button with a style that indicates a destructive
         /// action.
         /// - Parameters:
         ///   - label: The text to display on the button.
         ///   - action: A closure to execute when the user taps or presses the
         ///   button.
         /// - Returns: An alert button that indicates a destructive action.
         public static func destructive(_ label: Text, action: (() -> Void)? = {}) -> Alert.Button
     }
 }
 */

struct ColorSlider: View {
    @Binding var value: Double
    var trackColor: Color
    
    var body: some View {
        HStack {
            Text("0")
            // $value 会暴露出, 里面存储的 Subject 的值.
            Slider(value: $value)
                .accentColor(trackColor)
            Text("255")
        }
        .padding(.horizontal)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(guess: RGB())
    }
}
