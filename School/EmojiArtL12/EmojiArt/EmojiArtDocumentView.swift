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
    
    let defaultEmojiFontSize: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            PaletteChooser(emojiFontSize: defaultEmojiFontSize)
        }
    }
    
    /*
     在 SwiftUI 里面, Body 是一个计算属性, 取值的.
     各种 View 相关的属性, 都是计算属性.
     都是方法的调用.
     */
    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                /*
                 Summary

                 Layers a secondary view in front of this view.
                 Declaration

                 func overlay<Overlay>(_ overlay: Overlay, alignment: Alignment = .center) -> some View where Overlay : View
                 
                 When you apply an overlay to a view, the original view continues to provide the layout characteristics for the resulting view. In the following example, the heart image is shown overlaid in front of, and aligned to the bottom of the folder image.
                 Image(systemName: "folder")
                     .font(.system(size: 55, weight: .thin))
                     .overlay(Text("❤️"), alignment: .bottom)
                 
                 Returns

                 A view that layers overlay in front of the view.
                 
                 overlay 中返回的 View, 并不会影响到布局的变化.
                 从这里来看, 是真正的纯背景而已.
                 */
                Color.white.overlay(
                    OptionalImage(uiImage: document.backgroundImage)
                    /*
                     Summary

                     Scales this view’s rendered output by the given amount in both the horizontal and vertical directions, relative to an anchor point.
                     Declaration

                     func scaleEffect(_ s: CGFloat, anchor: UnitPoint = .center) -> some View
                     Discussion

                     Use scaleEffect(_:anchor:) to apply a horizontally and vertically scaling transform to a view.
                     Image(systemName: "envelope.badge.fill")
                         .resizable()
                         .frame(width: 100, height: 100, alignment: .center)
                         .foregroundColor(Color.red)
                         .scaleEffect(2, anchor: .leading)
                         .border(Color.gray)
                     Parameters

                     s
                     The amount to scale the view in the view in both the horizontal and vertical directions.
                     anchor
                     The anchor point with a default of UnitPoint/center that indicates the starting position for the scale operation.
                     */
                        .scaleEffect(zoomScale)
                    /*
                     Summary

                     Positions the center of this view at the specified point in its parent’s coordinate space.
                     Declaration

                     func position(_ position: CGPoint) -> some View
                     Discussion

                     Use the position(_:) modifier to place the center of a view at a specific coordinate in the parent view using a CGPoint to specify the x and y offset.
                     Text("Position by passing a CGPoint()")
                         .position(CGPoint(x: 175, y: 100))
                         .border(Color.gray)
                     Parameters

                     position
                     The point at which to place the center of this view.
                     Returns

                     A view that fixes the center of this view at position.
                     */
                    // Swift UI 没有使用 AutoLayout 的机制.
                    // 难道要静态布局吗. 从目前来看, GeometryReader position frame 就是在进行 Frame 的计算布局啊.
                        .position(convertFromEmojiCoordinates((0,0), in: geometry))
                )
                    .gesture(doubleTapToZoom(in: geometry.size))
                
                // 具体的内容视图. 和背景图的 Fetch 状态有关.
                if document.backgroundImageFetchStatus == .fetching {
                    ProgressView().scaleEffect(2)
                } else {
                    ForEach(document.emojis) { emoji in
                        Text(emoji.text)
                            .font(.system(size: fontSize(for: emoji)))
                            .scaleEffect(zoomScale)
                            .position(position(for: emoji, in: geometry))
                    }
                }
            }
            .clipped()
            /*
             Summary

             Defines the destination of a drag and drop operation that handles the dropped content with a closure that you specify.
             Declaration

             func onDrop(of supportedContentTypes: [UTType], isTargeted: Binding<Bool>?, perform action: @escaping ([NSItemProvider], CGPoint) -> Bool) -> some View
             Discussion

             The drop destination is the same size and position as this view.
             
             Parameters
             supportedContentTypes
             The uniform type identifiers that describe the types of content this view can accept through drag and drop. If the drag and drop operation doesn’t contain any of the supported types, then this drop destination doesn’t activate and isTargeted doesn’t update.
             isTargeted
             A binding that updates when a drag and drop operation enters or exits the drop target area. The binding’s value is true when the cursor is inside the area, and false when the cursor is outside.
             action
             A closure that takes the dropped content and responds appropriately. The first parameter to action contains the dropped items, with types specified by supportedContentTypes.
             The second parameter contains the drop location in this view’s coordinate space. Return true if the drop operation was successful; otherwise, return false.
             
             Returns
             A view that provides a drop destination for a drag operation of the specified types.
             */
            .onDrop(of: [.plainText,.url,.image], isTargeted: nil) { providers, location in
                drop(providers: providers, at: location, in: geometry)
            }
            /*
             Attaches a gesture to the view with a lower precedence than gestures defined by the view.
             Declaration

             func gesture<T>(_ gesture: T, including mask: GestureMask = .all) -> some View where T : Gesture
             Discussion

             Use this method when you need to attach a gesture to a view. The example below defines a custom gesture that prints a message to the console and attaches it to the view’s VStack. Inside the VStack a red heart Image defines its own TapGesture handler that also prints a message to the console, and blue rectangle with no custom gesture handlers.
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
                // return Alert
                alertToShow.alert()
            }
            // L12 monitor fetch status and alert user if fetch failed
            /*
             Adds a modifier for this view that fires an action when a specific value changes.
             Declaration

             // V 必须是 Equatable 的, 这样才能监听到变化.
             func onChange<V>(of value: V, perform action: @escaping (V) -> Void) -> some View where V : Equatable
             Discussion

             // such as an Environment key or a Binding, 这里对于检测对象, 是有要求的.
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
            // 从这里看, 应该是在这里, 监听了信号的变化, 然后调用传入的闭包.
            // onChanged 是专门做监听的.
            .onChange(of: document.backgroundImageFetchStatus) { status in
                switch status {
                case .failed(let url):
                    showBackgroundImageFetchFailedAlert(url)
                default:
                    break
                }
            }
        }
    }
    
    // L12 state which says whether a certain identifiable alert should be showing
    @State private var alertToShow: IdentifiableAlert?
    
    // L12 sets alertToShow to an IdentifiableAlert explaining a url fetch failure
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
    
    private func drop(providers: [NSItemProvider], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        var found = providers.loadObjects(ofType: URL.self) { url in
            document.setBackground(.url(url.imageURL))
        }
        if !found {
            found = providers.loadObjects(ofType: UIImage.self) { image in
                if let data = image.jpegData(compressionQuality: 1.0) {
                    document.setBackground(.imageData(data))
                }
            }
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                if let emoji = string.first, emoji.isEmoji {
                    document.addEmoji(
                        String(emoji),
                        at: convertToEmojiCoordinates(location, in: geometry),
                        size: defaultEmojiFontSize / zoomScale
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
    
    private func convertFromEmojiCoordinates(_ location: (x: Int, y: Int), in geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(
            x: center.x + CGFloat(location.x) * zoomScale + panOffset.width,
            y: center.y + CGFloat(location.y) * zoomScale + panOffset.height
        )
    }
    
    // MARK: - Zooming
    
    @State private var steadyStateZoomScale: CGFloat = 1
    @GestureState private var gestureZoomScale: CGFloat = 1
    
    private var zoomScale: CGFloat {
        steadyStateZoomScale * gestureZoomScale
    }
    
    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, _ in
                gestureZoomScale = latestGestureScale
            }
            .onEnded { gestureScaleAtEnd in
                steadyStateZoomScale *= gestureScaleAtEnd
            }
    }
    
    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    zoomToFit(document.backgroundImage, in: size)
                }
            }
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0, size.width > 0, size.height > 0  {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            steadyStatePanOffset = .zero
            steadyStateZoomScale = min(hZoom, vZoom)
        }
    }
    
    // MARK: - Panning
    
    @State private var steadyStatePanOffset: CGSize = CGSize.zero
    @GestureState private var gesturePanOffset: CGSize = CGSize.zero
    
    private var panOffset: CGSize {
        (steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    
    private func panGesture() -> some Gesture {
        /*
         A dragging motion that invokes an action as the drag-event sequence changes.
         Declaration

         struct DragGesture
         Discussion

         To recognize a drag gesture on a view, create and configure the gesture, and then add it to the view using the gesture(_:including:) modifier.
         Add a drag gesture to a Circle and change its color while the user performs the drag gesture:
         struct DragGestureView: View {
             @State var isDragging = false

         // 可以看到, 在系统给的示例代码里面, 也是使用计算属性, 来生成了 Body 中的内容. 
             var drag: some Gesture {
                 DragGesture()
                     .onChanged { _ in self.isDragging = true }
                     .onEnded { _ in self.isDragging = false }
             }

             var body: some View {
                 Circle()
                     .fill(self.isDragging ? Color.red : Color.blue)
                     .frame(width: 100, height: 100, alignment: .center)
                     .gesture(drag)
             }
         }
         */
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
