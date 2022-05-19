//
//  PaletteEditor.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 5/5/21.
//

import SwiftUI

struct PaletteEditor: View {
    @Binding var palette: PaletteCategory
    
    /*
     Summary

     A container for grouping controls used for data entry, such as in settings or inspectors.
     
     Declaration

     struct Form<Content> where Content : View
     Discussion

     SwiftUI applies platform-appropriate styling to views contained inside a form, to group them together. Form-specific styling applies to things like buttons, toggles, labels, lists, and more. Keep in mind that these stylings may be platform-specific. For example, forms apppear as grouped lists on iOS, and as aligned vertical stacks on macOS.
     The following example shows a simple data entry form on iOS, grouped into two sections. The supporting types (NotifyMeAboutType and ProfileImageSize) and state variables (notifyMeAbout, profileImageSize, playNotificationSounds, and sendReadReceipts) are omitted for simplicity.
     var body: some View {
         NavigationView {
             Form {
                 Section(header: Text("Notifications")) {
                     Picker("Notify Me About", selection: $notifyMeAbout) {
                         Text("Direct Messages").tag(NotifyMeAboutType.directMessages)
                         Text("Mentions").tag(NotifyMeAboutType.mentions)
                         Text("Anything").tag(NotifyMeAboutType.anything)
                     }
                     Toggle("Play notification sounds", isOn: $playNotificationSounds)
                     Toggle("Send read receipts", isOn: $sendReadReceipts)
                 }
                 Section(header: Text("User Profiles")) {
                     Picker("Profile Image Size", selection: $profileImageSize) {
                         Text("Large").tag(ProfileImageSize.large)
                         Text("Medium").tag(ProfileImageSize.medium)
                         Text("Small").tag(ProfileImageSize.small)
                     }
                     Button("Clear Image Cache") {}
                 }
             }
         }
     }
     On macOS, a similar form renders as a vertical stack. To adhere to macOS platform conventions, this version doesn’t use sections, and uses colons at the end of its labels. It also sets the picker to use the inline style, which produces radio buttons on macOS.
     var body: some View {
         Spacer()
         HStack {
             Spacer()
             Form {
                 Picker("Notify Me About:", selection: $notifyMeAbout) {
                     Text("Direct Messages").tag(NotifyMeAboutType.directMessages)
                     Text("Mentions").tag(NotifyMeAboutType.mentions)
                     Text("Anything").tag(NotifyMeAboutType.anything)
                 }
                 Toggle("Play notification sounds", isOn: $playNotificationSounds)
                 Toggle("Send read receipts", isOn: $sendReadReceipts)

                 Picker("Profile Image Size:", selection: $profileImageSize) {
                     Text("Large").tag(ProfileImageSize.large)
                     Text("Medium").tag(ProfileImageSize.medium)
                     Text("Small").tag(ProfileImageSize.small)
                 }
                 .pickerStyle(.inline)

                 Button("Clear Image Cache") {}
             }
             Spacer()
         }
         Spacer()
     }
     */
    var body: some View {
        Form {
            nameSection
            addEmojisSection
            removeEmojiSection
        }
        .navigationTitle("Edit \(palette.name)")
        .frame(minWidth: 300, minHeight: 350)
    }
    
    var nameSection: some View {
        Section(header: Text("Name")) {
            TextField("Name", text: $palette.name)
        }
    }
    
    @State private var emojisToAdd = ""
    
    var addEmojisSection: some View {
        Section(header: Text("Add Emojis")) {
            TextField("", text: $emojisToAdd)
            // 没有直接 Bind 到 palette.emojis 上, 不应该在这里, 把已有的表情都显示出来.
            // 用户新输入什么, 在这显示什么, 然后将输入的显示, 添加到 palette 中.
            // 这种, 临时绑定到一个成员变量, 然后更改之后做事情, 触发场景非常非常广. 
                .onChange(of: emojisToAdd) { emojis in
                    addEmojis(emojis)
                }
        }
    }
    
    func addEmojis(_ emojis: String) {
        withAnimation {
            palette.emojis = (emojis + palette.emojis)
                .filter { $0.isEmoji }
                .removingDuplicateCharacters
        }
    }
    
    var removeEmojiSection: some View {
        Section(header: Text("Remove Emoji")) {
            let emojis = palette.emojis.removingDuplicateCharacters.map { String($0) }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                palette.emojis.removeAll(where: { String($0) == emoji })
                            }
                        }
                }
            }
            .font(.system(size: 40))
        }
    }
}

struct PaletteEditor_Previews: PreviewProvider {
    static var previews: some View {
        PaletteEditor(palette: .constant(PaletteStore(named: "Preview").palette(at: 4)))
            .previewLayout(.fixed(width: 300, height: 350))
        PaletteEditor(palette: .constant(PaletteStore(named: "Preview").palette(at: 2)))
            .previewLayout(.fixed(width: 300, height: 600))
    }
}
