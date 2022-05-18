//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 4/26/21.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    @Environment(\.undoManager) var undoManager
    
    @ScaledMetric var defaultEmojiFontSize: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            PaletteChooser(emojiFontSize: defaultEmojiFontSize)
        }
    }
    
    // 在 SwiftUI 中, 这种计算属性, 其实非常常见. 
    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                // L15 don't need this as an .overlay anymore
                // L15 we explicitly position it in the ZStack
                OptionalImage(uiImage: document.backgroundImage)
                    .scaleEffect(zoomScale)
                    .position(convertFromEmojiCoordinates((0,0), in: geometry))
                .gesture(doubleTapToZoom(in: geometry.size))
                
                if document.backgroundImageFetchStatus == .fetching {
                    /*
                     A view that shows the progress towards completion of a task.
                     Declaration

                     struct ProgressView<Label, CurrentValueLabel> where Label : View, CurrentValueLabel : View
                     Discussion

                     Use a progress view to show that a task is making progress towards completion. A progress view can show both determinate (percentage complete) and indeterminate (progressing or not) types of progress.
                     Create a determinate progress view by initializing a ProgressView with a binding to a numeric value that indicates the progress, and a total value that represents completion of the task. By default, the progress is 0.0 and the total is 1.0.
                     The example below uses the state property progress to show progress in a determinate ProgressView. The progress view uses its default total of 1.0, and because progress starts with an initial value of 0.5, the progress view begins half-complete. A “More” button below the progress view allows the user to increment the progress in 5% increments:
                     @State private var progress = 0.5

                     VStack {
                         ProgressView(value: progress)
                         Button("More", action: { progress += 0.05 })
                     }
                     To create an indeterminate progress view, use an initializer that doesn’t take a progress value:
                     var body: some View {
                         ProgressView()
                     }
                     */
                    ProgressView().scaleEffect(2)
                } else {
                    ForEach(document.emojis) { emoji in
                        Text(emoji.text)
                            .font(.system(size: fontSize(for: emoji)))
                        /*
                         Scales this view’s rendered output by the given amount in both the horizontal and vertical directions, relative to an anchor point.
                         Declaration
                         func scaleEffect(_ s: CGFloat, anchor: UnitPoint = .center) -> some View
                         */
                            .scaleEffect(zoomScale)
                        // Position 的显示使用, 使得原有的 Frame 编程, 变为了可能.
                            .position(position(for: emoji, in: geometry))
                    }
                }
            }
            /*
             Summary

             Clips this view to its bounding rectangular frame.
             Declaration

             func clipped(antialiased: Bool = false) -> some View
             Discussion

             Use the clipped(antialiased:) modifier to hide any content that extends beyond the layout bounds of the shape.
             By default, a view’s bounding frame is used only for layout, so any content that extends beyond the edges of the frame is still visible.
             Text("This long text string is clipped")
                 .fixedSize()
                 .frame(width: 175, height: 100)
                 .clipped()
                 .border(Color.gray)
             Parameters

             antialiased
             A Boolean value that indicates whether the rendering system applies smoothing to the edges of the clipping rectangle.
             Returns

             A view that clips this view to its bounding frame.
             */
            .clipped()
            /*
             Declaration
             func onDrop(of supportedContentTypes: [UTType], isTargeted: Binding<Bool>?, perform action: @escaping ([NSItemProvider], CGPoint) -> Bool) -> some View
             Return Value
             A view that provides a drop destination for a drag operation of the specified types.
             
             Parameters
             supportedContentTypes
             The uniform type identifiers that describe the types of content this view can accept through drag and drop. If the drag and drop operation doesn’t contain any of the supported types, then this drop destination doesn’t activate and isTargeted doesn’t update.
             isTargeted
             A binding that updates when a drag and drop operation enters or exits the drop target area. The binding’s value is true when the cursor is inside the area, and false when the cursor is outside.
             action
             A closure that takes the dropped content and responds appropriately. The first parameter to action contains the dropped items, with types specified by supportedContentTypes. The second parameter contains the drop location in this view’s coordinate space. Return true if the drop operation was successful; otherwise, return false.
             Discussion
             The drop destination is the same size and position as this view.
             */
            .onDrop(of: [.utf8PlainText,.url,.image], isTargeted: nil) { providers, location in
                drop(providers: providers, at: location, in: geometry)
            }
            /*
             Attaches a gesture to the view with a lower precedence than gestures defined by the view.
             Declaration

             func gesture<T>(_ gesture: T, including mask: GestureMask = .all) -> some View where T : Gesture
             Discussion

             Use this method when you need to attach a gesture to a view. The example below defines a custom gesture that prints a message to the console and attaches it to the view’s VStack.
             Inside the VStack a red heart Image defines its own TapGesture handler that also prints a message to the console, and blue rectangle with no custom gesture handlers.
             Tapping or clicking the image prints a message to the console from the tap gesture handler on the image, while tapping or clicking the rectangle inside the VStack prints a message in the console from the enclosing vertical stack gesture handler.
             struct GestureExample: View {
                 @State private var message = "Message"
                 let newGesture = TapGesture().onEnded {
                     print("Tap on VStack.")
                 }

                 var body: some View {
                     VStack(spacing:25) {
                         Image(systemName: "heart.fill")
                             .resizable()
                             .frame(width: 75, height: 75)
                             .padding()
                             .foregroundColor(.red)
                             .onTapGesture {
                                 print("Tap on image.")
                             }
                         Rectangle()
                             .fill(Color.blue)
                     }
                     .gesture(newGesture)
                     .frame(width: 200, height: 200)
                     .border(Color.purple)
                 }
             }
             Parameters

             gesture
             A gesture to attach to the view.
             mask
             A value that controls how adding this gesture to the view affects other gestures recognized by the view and its subviews. Defaults to all.
             */
            .gesture(panGesture().simultaneously(with: zoomGesture()))
            .alert(item: $alertToShow) { alertToShow in
                alertToShow.alert()
            }
            /*
             Summary

             Adds a modifier for this view that fires an action when a specific value changes.
             Declaration

             func onChange<V>(of value: V, perform action: @escaping (V) -> Void) -> some View where V : Equatable
             Discussion

             You can use onChange to trigger a side effect as the result of a value changing, such as an Environment key or a Binding.
             onChange is called on the main thread. Avoid performing long-running tasks on the main thread. If you need to perform a long-running task in response to value changing, you should dispatch to a background queue.
             The new value is passed into the closure. The previous value may be captured by the closure to compare it to the new value. For example, in the following code example, PlayerView passes both the old and new values to the model.
             struct PlayerView: View {
                 var episode: Episode
                 @State private var playState: PlayState = .paused

                 var body: some View {
                     VStack {
                         Text(episode.title)
                         Text(episode.showTitle)
                         PlayButton(playState: $playState)
                     }
                     .onChange(of: playState) { [playState] newState in
                         model.playStateDidChange(from: playState, to: newState)
                     }
                 }
             }
             Parameters

             value
             The value to check against when determining whether to run the closure.
             action
             A closure to run when the value changes.
             newValue
             The new value that failed the comparison check.
             Returns

             A view that fires an action when the specified value changes.
             */
            .onChange(of: document.backgroundImageFetchStatus) { status in
                switch status {
                case .failed(let url):
                    showBackgroundImageFetchFailedAlert(url)
                default:
                    break
                }
            }
            /*
             Summary

             Adds an action to perform when this view detects data emitted by the given publisher.
             Declaration

             func onReceive<P>(_ publisher: P, perform action: @escaping (P.Output) -> Void) -> some View where P : Publisher, P.Failure == Never
             Parameters

             publisher
             The publisher to subscribe to.
             action
             The action to perform when an event is emitted by publisher. The event emitted by publisher is passed as a parameter to action.
             Returns

             A view that triggers action when publisher emits an event.
             */
            .onReceive(document.$backgroundImage) { image in
                if autozoom {
                    zoomToFit(image, in: geometry.size)
                }
            }
            // L15 added background-setting and undo/redo operations to the navigation toolbar
            // L15 but since only one button can appear there in .compact horizontal settings
            // L15 we use .compactableToolbar to turn it into a single button with context menu in that case
            .compactableToolbar {
                // L15 add background-setting via pasteboard
                // L15 especially useful on iPhone since no drag-and-drop there
                AnimatedActionButton(title: "Paste Background", systemImage: "doc.on.clipboard") {
                    pasteBackground()
                }
                // L15 add background-setting via taking a photo with the camera
                if Camera.isAvailable {
                    AnimatedActionButton(title: "Take Photo", systemImage: "camera") {
                        backgroundPicker = .camera
                    }
                }
                // L15 add background-setting by choosing a photo from the user's photo library
                if PhotoLibrary.isAvailable {
                    AnimatedActionButton(title: "Search Photos", systemImage: "photo") {
                        backgroundPicker = .library
                    }
                }
                // L15 unrolled undo and redo from context menu into toolbar
                // L16 don't need undo and redo buttons on macOS because we have an Edit menu
                #if os(iOS)
                if let undoManager = undoManager {
                    if undoManager.canUndo {
                        AnimatedActionButton(title: undoManager.undoActionName, systemImage: "arrow.uturn.backward") {
                            undoManager.undo()
                        }
                    }
                    if undoManager.canRedo {
                        AnimatedActionButton(title: undoManager.redoActionName, systemImage: "arrow.uturn.forward") {
                            undoManager.redo()
                        }
                    }
                }
                #endif
            }
            // L15 puts up a sheet to show either the camera or photo library
            // L15 see Camera.swift and PhotoLibrary.swift
            .sheet(item: $backgroundPicker) { pickerType in
                switch pickerType {
                case .camera: Camera(handlePickedImage: { image in handlePickedBackgroundImage(image) })
                case .library: PhotoLibrary(handlePickedImage: { image in handlePickedBackgroundImage(image) })
                }
            }
        }
    }
    
    // L15 @State which controls whether the camera or photo-library sheet (or neither) is up
    @State private var backgroundPicker: BackgroundPickerType?
    
    // L15 enum to control which photo-picking sheet to show
    enum BackgroundPickerType: Identifiable {
        case camera
        case library
        var id: BackgroundPickerType { self }
    }
    
    // L15 handler for an image from camera or photo library
    private func handlePickedBackgroundImage(_ image: UIImage?) {
        autozoom = true
        if let imageData = image?.imageData {
            document.setBackground(.imageData(imageData), undoManager: undoManager)
        }
        backgroundPicker = nil
    }
    
    // L15 set the background from whatever's in the pasteboard
    private func pasteBackground() {
        autozoom = true
        if let imageData = Pasteboard.imageData { // L16 made cross-platform
            document.setBackground(.imageData(imageData), undoManager: undoManager)
        } else if let url = Pasteboard.imageURL { // L16 made cross-platform
            document.setBackground(.url(url), undoManager: undoManager)
        } else {
            alertToShow = IdentifiableAlert(
                title: "Paste Background",
                message: "There is no image currently on the pasteboard."
            )
        }
    }
    
    @State private var autozoom = false
    
    @State private var alertToShow: IdentifiableAlert?
    
    private func showBackgroundImageFetchFailedAlert(_ url: URL) {
        alertToShow = IdentifiableAlert(id: "fetch failed: " + url.absoluteString, alert: {
            Alert(
                title: Text("Background Image Fetch"),
                message: Text("Couldn't load image from \(url)."),
                dismissButton: .default(Text("OK"))
            )
        })
    }
    
    // MARK: - Drag and Drop
    
    /*
     这是一个带有返回值的函数, 目的是和系统 API 交互. 但是, 带有副作用. 当返回值是 True 的时候, 会异步做 data 的抽取, 然后修改 Model.
     这些副作用, 是业务相关的逻辑.
     */
    private func drop(providers: [NSItemProvider], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        var found = providers.loadObjects(ofType: URL.self) { url in
            autozoom = true
            document.setBackground(.url(url.imageURL), undoManager: undoManager)
        }
        // L16 NSImage does not have an NSItemProvider
        // L16 TODO: figure out a way to drop an NSImage on macOS?
        // L16 (still doable via URL code above for now)
        #if os(iOS)
        if !found {
            found = providers.loadObjects(ofType: UIImage.self) { image in
                if let data = image.jpegData(compressionQuality: 1.0) {
                    autozoom = true
                    document.setBackground(.imageData(data), undoManager: undoManager)
                }
            }
        }
        #endif
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                if let emoji = string.first, emoji.isEmoji {
                    document.addEmoji(
                        String(emoji),
                        at: convertToEmojiCoordinates(location, in: geometry),
                        size: defaultEmojiFontSize / zoomScale,
                        undoManager: undoManager
                    )
                }
            }
        }
        return found
    }
    
    // MARK: - Positioning/Sizing Emoji
    
    private func position(for emoji: EmojiArtModel.Emoji, in geometry: GeometryProxy) -> CGPoint {
        convertFromEmojiCoordinates((emoji.x, emoji.y), in: geometry)
    }
    
    private func fontSize(for emoji: EmojiArtModel.Emoji) -> CGFloat {
        CGFloat(emoji.size)
    }
    
    private func convertToEmojiCoordinates(_ location: CGPoint, in geometry: GeometryProxy) -> (x: Int, y: Int) {
        let center = geometry.frame(in: .local).center
        let location = CGPoint(
            x: (location.x - panOffset.width - center.x) / zoomScale,
            y: (location.y - panOffset.height - center.y) / zoomScale
        )
        return (Int(location.x), Int(location.y))
    }
    
    // 以, 当前 Doc View 的中心为原点, 进行 Point 的变化.
    // X, Y 记录的是, 中心点的变化. 这样, 无论是在什么屏幕上, 都可以正常的进行布局了.
    private func convertFromEmojiCoordinates(_ location: (x: Int, y: Int), in geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(
            x: center.x + CGFloat(location.x) * zoomScale + panOffset.width,
            y: center.y + CGFloat(location.y) * zoomScale + panOffset.height
        )
    }
    
    // MARK: - Zooming
    
    @SceneStorage("EmojiArtDocumentView.steadyStateZoomScale")
    private var steadyStateZoomScale: CGFloat = 1
    
    /*
     A property wrapper type that updates a property while the user performs a gesture and resets the property back to its initial state when the gesture ends.
     */
    @GestureState private var gestureZoomScale: CGFloat = 1
    
    private var zoomScale: CGFloat {
        steadyStateZoomScale * gestureZoomScale
    }
    
    private func zoomGesture() -> some Gesture {
        /*
         /// A gesture that recognizes a magnification motion and tracks the amount of
         /// magnification.
         
         /// A magnification gesture tracks how a magnification event sequence changes.
         /// To recognize a magnification gesture on a view, create and configure the
         /// gesture, and then add it to the view using the
         /// ``View/gesture(_:including:)`` modifier.
         
         /// Add a magnification gesture to a ``Circle`` that changes its size while the
         /// user performs the gesture:
         ///
         ///     struct MagnificationGestureView: View {
         ///
         ///         @GestureState var magnifyBy = 1.0
         ///
         ///         var magnification: some Gesture {
         ///             MagnificationGesture()
         ///                 .updating($magnifyBy) { currentState, gestureState, transaction in
         ///                     gestureState = currentState
         ///                 }
         ///         }
         ///
         ///         var body: some View {
         ///             Circle()
         ///                 .frame(width: 100, height: 100)
         ///                 .scaleEffect(magnifyBy)
         ///                 .gesture(magnification)
         ///         }
         ///     }
         ///
         /// The circle's size resets to its original size when the gesture finishes.
         */
        MagnificationGesture()
        /*
         /// Updates the provided gesture state property as the gesture's value
         /// changes.
         
         ///   - state: A binding to a view's ``GestureState`` property.
         ///   - body: The callback that SwiftUI invokes as the gesture's value
         ///     changes. Its `currentState` parameter is the updated state of the
         ///     gesture. The `gestureState` parameter is the previous state of the
         ///     gesture, and the `transaction` is the context of the gesture.
         
         /// - Returns: A version of the gesture that updates the provided `state` as
         ///   the originating gesture's value changes, and that resets the `state`
         ///   to its initial value when the users cancels or ends the gesture.
         @inlinable public func updating<State>(_ state: GestureState<State>, body: @escaping (Self.Value, inout State, inout Transaction) -> Void) -> GestureStateGesture<Self, State>
         */
            .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, _ in
                gestureZoomScale = latestGestureScale
            }
            .onEnded { gestureScaleAtEnd in
                // 当, onEnd 的时候, gestureZoomScale 会重新设置为 1. 然后 steadyStateZoomScale 掌管所有的 Zoom 相关的数值. 
                steadyStateZoomScale *= gestureScaleAtEnd
            }
    }
    
    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                // 在 View Action 中, 使用 withAnimation 进行包装, 是一个非常非常普遍的行为.
                withAnimation {
                    zoomToFit(document.backgroundImage, in: size)
                }
            }
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0,
            image.size.height > 0,
            size.width > 0,
            size.height > 0  {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            // 在方法内, 进行数值的修改. 然后, View 自动变化到对应的数值.
            steadyStatePanOffset = .zero
            steadyStateZoomScale = min(hZoom, vZoom)
        }
    }
    
    // MARK: - Panning
    
    @SceneStorage("EmojiArtDocumentView.steadyStatePanOffset")
    private var steadyStatePanOffset: CGSize = CGSize.zero
    @GestureState private var gesturePanOffset: CGSize = CGSize.zero
    
    private var panOffset: CGSize {
        (steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    
    /*
     /// Updates the provided gesture state property as the gesture's value
     /// changes.
     ///
     /// Use this callback to update transient UI state as described in
     /// <doc:Adding-Interactivity-with-Gestures>.
     ///
     /// - Parameters:
     ///   - state: A binding to a view's ``GestureState`` property.
     ///   - body: The callback that SwiftUI invokes as the gesture's value
     ///     changes. Its `currentState` parameter is the updated state of the
     ///     gesture. The `gestureState` parameter is the previous state of the
     ///     gesture, and the `transaction` is the context of the gesture.
     ///
     /// - Returns: A version of the gesture that updates the provided `state` as
     ///   the originating gesture's value changes, and that resets the `state`
     ///   to its initial value when the users cancels or ends the gesture.
     */
    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, _ in
                gesturePanOffset = latestDragGestureValue.translation / zoomScale
            }
            .onEnded { finalDragGestureValue in
                steadyStatePanOffset = steadyStatePanOffset + (finalDragGestureValue.translation / zoomScale)
            }
    }
}






















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView(document: EmojiArtDocument())
    }
}
