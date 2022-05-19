//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 5/5/21.
//

import SwiftUI

struct PaletteChooser: View {
    var emojiFontSize: CGFloat = 40
    var emojiFont: Font { .system(size: emojiFontSize) }
    
    @EnvironmentObject var store: PaletteStore
    
    @SceneStorage("PaletteChooser.chosenPaletteIndex")
    private var chosenPaletteIndex = 0
    
    var body: some View {
        HStack {
            paletteControlButton
            body(for: store.palette(at: chosenPaletteIndex))
        }
        .clipped()
    }
    
    var paletteControlButton: some View {
        /*
         Button 中, 存储点击闭包, 以及这个 Button 的真正的显示.
         显式地进行 chosenPaletteIndex 的修改, 在 SwfitUI 里面, 动画是一个非常容易达成的效果.
         */
        Button {
            withAnimation {
                chosenPaletteIndex = (chosenPaletteIndex + 1) % store.palettes.count
            }
        } label: {
            Image(systemName: "paintpalette")
        }
        .font(emojiFont)
        .paletteControlButtonStyle() // L16 see macOS.swift
        .contextMenu { contextMenu }
    }
    
    /*
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
     */
    
    @ViewBuilder
    /*
     contextMenu 是一个 ViewBuilder. 会将里面的内容, 合并成为一个 TupleView.
     */
    var contextMenu: some View {
        AnimatedActionButton(title: "Edit", systemImage: "pencil") {
            paletteToEdit = store.palette(at: chosenPaletteIndex)
        }
        AnimatedActionButton(title: "New", systemImage: "plus") {
            store.insertPalette(named: "New", emojis: "", at: chosenPaletteIndex)
            paletteToEdit = store.palette(at: chosenPaletteIndex)
        }
        AnimatedActionButton(title: "Delete", systemImage: "minus.circle") {
            chosenPaletteIndex = store.removePalette(at: chosenPaletteIndex)
        }
        // L16 no EditMode on macOS, so no PaletteManager
#if os(iOS)
        AnimatedActionButton(title: "Manager", systemImage: "slider.vertical.3") {
            managing = true
        }
#endif
        gotoMenu
    }
    
    /*
     Summary
     A control for presenting a menu of actions.
     Declaration

     struct Menu<Label, Content> where Label : View, Content : View
     Discussion

     The following example presents a menu of three buttons and a submenu, which contains three buttons of its own.
     Menu("Actions") {
         Button("Duplicate", action: duplicate)
         Button("Rename", action: rename)
         Button("Delete…", action: delete)
         Menu("Copy") {
             Button("Copy", action: copy)
             Button("Copy Formatted", action: copyFormatted)
             Button("Copy Library Path", action: copyPath)
         }
     }
     You can create the menu’s title with a LocalizedStringKey, as seen in the previous example, or with a view builder that creates multiple views, such as an image and a text view:
     Menu {
         Button("Open in Preview", action: openInPreview)
         Button("Save as PDF", action: saveAsPDF)
     } label: {
         Label("PDF", systemImage: "doc.fill")
     }
     */
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
    
    // 这种, Body 开头的臭毛病, 看来是从白胡子老头这里走出来的.
    func body(for palette: PaletteCategory) -> some View {
        HStack {
            Text(palette.name)
            ScrollingEmojisView(emojis: palette.emojis)
                .font(emojiFont)
        }
        .id(palette.id)
        .transition(rollTransition)
        .popover(item: $paletteToEdit) { palette in
            PaletteEditor(palette: $store.palettes[palette])
            // L16 see macOS.swift
                .popoverPadding()
            // L15 make this popover dismissable with a Close button on iPhone
                .wrappedInNavigationViewToMakeDismissable { paletteToEdit = nil }
        }
        // 当, managing 改变的时候, Sheet 进行出现. 
        .sheet(isPresented: $managing) {
            PaletteManager()
        }
    }
    
    @State private var managing = false
    @State private var paletteToEdit: PaletteCategory?
    
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
            // 如果, 这里不用 HStack 包装一层, 那么 ForEach 生成的 View, 是从上到下进行的罗列.
            HStack {
                ForEach(emojis.removingDuplicateCharacters.map { String($0) }, id: \.self) { emoji in
                    Text(emoji)
                    // Drag 的操作, 直接是使用了系统提供的 API, 这也是 Swfit UI 快的原因所在.
                        .onDrag { NSItemProvider(object: emoji as NSString) }
                }
            }
//            ForEach(emojis.removingDuplicateCharacters.map { String($0) }, id: \.self) { emoji in
//                Text(emoji)
//                // Drag 的操作, 直接是使用了系统提供的 API, 这也是 Swfit UI 快的原因所在.
//                    .onDrag { NSItemProvider(object: emoji as NSString) }
//            }
        }
    }
}

struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser()
    }
}
