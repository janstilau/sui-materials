//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 5/5/21.
//

import SwiftUI

// L12 the main View of the Palette-choosing MVVM at the bottom of the screen

struct PaletteChooser: View {
    var emojiFontSize: CGFloat = 40
    // Swfit 经常, 使用这种计算属性, 来方便操作.
    // 个人不喜欢
    var emojiFont: Font { .system(size: emojiFontSize) }
    
    @EnvironmentObject var store: PaletteStore
    
    @State private var chosenPaletteIndex = 0
    
    var body: some View {
        HStack {
            paletteControlButton
            // 真正的内容, 是根据 chosenPaletteIndex 不断的变化的. View 作为 Model 的映射函数.
            // 这也是, 为什么 chosenPaletteIndex 的变化, 会引起整个 ChooseBox 的变化了.
            body(for: store.palette(at: chosenPaletteIndex))
        }
        /*
         Clips this view to its bounding rectangular frame.
         
         func clipped(antialiased: Bool = false) -> some View
         
         Use the clipped(antialiased:) modifier to hide any content that extends beyond the layout bounds of the shape.
         By default, a view’s bounding frame is used only for layout.
         so any content that extends beyond the edges of the frame is still visible.
         
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
         Adds a border to this view with the specified style and width.
         
         func border<S>(_ content: S, width: CGFloat = 1) -> some View where S : ShapeStyle
         Discussion
         
         Use this modifier to draw a border of a specified width around the view’s frame. By default, the border appears inside the bounds of this view. For example, you can add a four-point wide border covers the text:
         Text("Purple border inside the view bounds.")
         .border(Color.purple, width: 4)
         To place a border around the outside of this view, apply padding of the same width before adding the border:
         Text("Purple border outside the view bounds.")
         .padding(4)
         .border(Color.purple, width: 4)
         Parameters
         
         content
         A value that conforms to the ShapeStyle protocol, like a Color or HierarchicalShapeStyle, that SwiftUI uses to fill the border.
         width
         The thickness of the border. The default is 1 pixel.
         Returns
         
         A view that adds a border with the specified style and width to this view.
         */
        // Border 应该仅仅是为了进行信息的存储操作.
        // 我个人猜测, 是有一个 storage 进行真正的存储, 然后所有的操作, 都是为了在 Storage 里面, 进行值的赋值而已.
        // 所以 View Struct 都存储着该 storage 对象. 使用 View Struct 来保持, some View 的抽象.
        .border(Color.red)
    }
    
    var paletteControlButton: some View {
        Button {
            withAnimation {
                // ViewAction 中, 触发的是 Model 的变化.
                // 由于 View 是 Model 的映射, 所以 Model 的变化, 直接引起 View 的变化. 在 IntentAction 中, 进行 withAnimation 的显示调用, 使得 View 的变化, 动态化
                chosenPaletteIndex = (chosenPaletteIndex + 1) % store.palettes.count
            }
        } label: {
            Image(systemName: "paintpalette")
        }
        .font(emojiFont)
        /*
         Adds a context menu to the view.
         func contextMenu<MenuItems>(menuItems: () -> MenuItems) -> some View where MenuItems : View
         
         Use contextual menus to add actions that change depending on the user’s current focus and task.
         The following example creates a Text view with a contextual menu. Note that the actions invoked by the menu selection could be coded directly inside the button closures or, as shown below, invoked via function references.
         func selectHearts() {
         // Act on hearts selection.
         }
         func selectClubs() { ... }
         func selectSpades() { ... }
         func selectDiamonds() { ... }
         
         Text("Favorite Card Suit")
         .padding()
         .contextMenu {
         Button("♥️ - Hearts", action: selectHearts)
         Button("♣️ - Clubs", action: selectClubs)
         Button("♠️ - Spades", action: selectSpades)
         Button("♦️ - Diamonds", action: selectDiamonds)
         }
         A contextMenu that contains one or more menu items.
         A view that adds a contextual menu to this view.
         */
        // 使用 contextMenu 可以, 可以为 View 增加一个长按点击弹出菜单的效果.
        // public func contextMenu<MenuItems>(@ViewBuilder menuItems: () -> MenuItems) -> some View where MenuItems : View
        // contextMenu 的形参, 是一个 ViewBuilder, 所以可以直接在其中, 使用上面 View 罗列的形式.
        .contextMenu { contextMenu }
    }
    
    @ViewBuilder
    var contextMenu: some View {
        // paletteToEdit 是一个 ViewState 值, 修改之后, 可以直接改变 View.
        // AnimatedActionButton 的存在, 使得 Button 触发的 Action, 都会在 withAnimation 的环境下进行触发.
        AnimatedActionButton(title: "Edit", systemImage: "pencil") {
            //            editing = true
            paletteToEdit = store.palette(at: chosenPaletteIndex)
        }
        AnimatedActionButton(title: "New", systemImage: "plus") {
            store.insertPalette(named: "New", emojis: "", at: chosenPaletteIndex)
            //            editing = true
            paletteToEdit = store.palette(at: chosenPaletteIndex)
        }
        AnimatedActionButton(title: "Delete", systemImage: "minus.circle") {
            chosenPaletteIndex = store.removePalette(at: chosenPaletteIndex)
        }
        AnimatedActionButton(title: "Manager", systemImage: "slider.vertical.3") {
            managing = true
        }
        gotoMenu
    }
    
    //    @State private var editing = false
    @State private var managing = false
    @State private var paletteToEdit: Palette?
    
    func body(for palette: Palette) -> some View {
        HStack {
            Text(palette.name)
            ScrollingEmojisView(emojis: palette.emojis)
                .font(emojiFont)
        }
        /*
         /// Binds a view's identity to the given proxy value.
         ///
         /// When the proxy value specified by the `id` parameter changes, the
         /// identity of the view — for example, its state — is reset.
         */
        .id(palette.id)
        /// Associates a transition with the view.
        .transition(rollTransition)
        //        .popover(isPresented: $editing) {
        //            PaletteEditor(palette: $store.palettes[chosenPaletteIndex])
        //        }
        .popover(item: $paletteToEdit) { palette in
            PaletteEditor(palette: $store.palettes[palette])
        }
        .sheet(isPresented: $managing) {
            PaletteManager()
        }
    }
    
    var gotoMenu: some View {
        Menu {
            ForEach (store.palettes) { palette in
                AnimatedActionButton(title: palette.name) {
                    if let index = store.palettes.index(matching: palette) {
                        chosenPaletteIndex = index
                    }
                }
            }
        } label: {
            Label("Go To", systemImage: "text.insert")
        }
    }
    
    var rollTransition: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .offset(x: 0, y: emojiFontSize),
            removal: .offset(x: 0, y: -emojiFontSize)
        )
    }
}

struct ScrollingEmojisView: View {
    let emojis: String
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis.removingDuplicateCharacters.map { String($0) }, id: \.self) { emoji in
                    // 整个拖动的行为如何实现的, 其实并没有暴露给外界.
                    Text(emoji)
                    /*
                     Summary
                     
                     Activates this view as the source of a drag and drop operation.
                     Declaration
                     
                     func onDrag(_ data: @escaping () -> NSItemProvider) -> some View
                     Discussion
                     
                     Applying the onDrag(_:) modifier adds the appropriate gestures for drag and drop to this view. When a drag operation begins, a rendering of this view is generated and used as the preview image.
                     Parameters
                     
                     data
                     A closure that returns a single NSItemProvider that represents the draggable data from this view.
                     Returns
                     
                     A view that activates this view as the source of a drag and drop operation, beginning with user gesture input.
                     */
                    /*
                     从上面的描述, 可以看到其实 Drag 这件事, 和自己的实现思路没有太大的区别.
                     Drag 发生的时候, 其实是重新 Render 一个被拖拽的对象, 然后该对象其实就是一个顶层的临时对象, 随着拖动手势移动位置.
                     随着拖动的发生是, 其实要传递一些信息过去, 这就是 NSItemProvider 存在的意义.
                     当 onDrop 的时候, 临时渲染的 View 离开屏幕, onDrop 的 View 接收到 NSItemProvider 对象, 将对应的数据, 渲染到指定的位置.
                     
                     整个的过程, 被 SwiftUI 接管, 给用户暴露的, 仅仅是数据的传递, 以及 onDrop 后的 View 更新相关逻辑.
                     */
                        .onDrag { NSItemProvider(object: emoji as NSString) }
                }
            }
        }
    }
}

struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser()
    }
}
