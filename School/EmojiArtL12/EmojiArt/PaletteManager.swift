
import SwiftUI

struct PaletteManager: View {
    /*
     A property wrapper type for an observable object supplied by a parent or ancestor view.
     
     @frozen @propertyWrapper struct EnvironmentObject<ObjectType> where ObjectType : ObservableObject
     
     An environment object invalidates the current view whenever the observable object changes.
     If you declare a property as an environment object, be sure to set a corresponding model object on an ancestor view by calling its environmentObject(_:) modifier.
     */
    /*
     从文档可以看出, @EnvironmentObject 修饰的, 其实必须是一个 ObservableObject 对象.
     必须在父 View 中进行提前的赋值.
     
     所以, 实际上这就是一个方便传值的机制.
     */
    @EnvironmentObject var store: PaletteStore
    
    // a Binding to a PresentationMode
    // which lets us dismiss() ourselves if we are isPresented
    @Environment(\.presentationMode) var presentationMode
    
    // we inject a Binding to this in the environment for the List and EditButton
    // using the \.editMode in EnvironmentValues
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List {
                /*
                 Summary
                 
                 A structure that computes views on demand from an underlying collection of identified data.
                 Declaration
                 
                 struct ForEach<Data, ID, Content> where Data : RandomAccessCollection, ID : Hashable
                 Discussion
                 
                 Use ForEach to provide views based on a RandomAccessCollection of some data type. Either the collection’s elements must conform to Identifiable or you need to provide an id parameter to the ForEach initializer.
                 The following example creates a NamedFont type that conforms to Identifiable, and an array of this type called namedFonts. A ForEach instance iterates over the array, producing new Text instances that display examples of each SwiftUI Font style provided in the array.
                 private struct NamedFont: Identifiable {
                 let name: String
                 let font: Font
                 var id: String { name }
                 }
                 
                 private let namedFonts: [NamedFont] = [
                 NamedFont(name: "Large Title", font: .largeTitle),
                 NamedFont(name: "Title", font: .title),
                 NamedFont(name: "Headline", font: .headline),
                 NamedFont(name: "Body", font: .body),
                 NamedFont(name: "Caption", font: .caption)
                 ]
                 
                 var body: some View {
                 ForEach(namedFonts) { namedFont in
                 Text(namedFont.name)
                 .font(namedFont.font)
                 }
                 }
                 */
                ForEach(store.palettes) { palette in
                    // tapping on this row in the List will navigate to a PaletteEditor
                    // (not subscripting by the Identifiable)
                    // (see the subscript added to RangeReplaceableCollection in UtilityExtensiosn)
                    NavigationLink(destination: PaletteEditor(palette: $store.palettes[palette])) {
                        VStack(alignment: .leading) {
                            Text(palette.name)
                            Text(palette.emojis)
                        }
                        // tapping when NOT in editMode will follow the NavigationLink
                        // (that's why gesture is set to nil in that case)
                        .gesture(editMode == .active ? tap : nil)
                    }
                }
                // teach the ForEach how to delete items
                // at the indices in indexSet from its array
                .onDelete { indexSet in
                    store.palettes.remove(atOffsets: indexSet)
                }
                // teach the ForEach how to move items
                // at the indices in indexSet to a newOffset in its array
                .onMove { indexSet, newOffset in
                    store.palettes.move(fromOffsets: indexSet, toOffset: newOffset)
                }
            }
            .navigationTitle("Manage Palettes")
            .navigationBarTitleDisplayMode(.inline)
            // add an EditButton on the trailing side of our NavigationView
            // and a Close button on the leading side
            // notice we are adding this .toolbar to the List
            // (not to the NavigationView)
            // (NavigationView looks at the View it is currently showing for toolbar info)
            // (ditto title and titledisplaymode above)
            .toolbar {
                ToolbarItem { EditButton() }
                ToolbarItem(placement: .navigationBarLeading) {
                    if presentationMode.wrappedValue.isPresented,
                       UIDevice.current.userInterfaceIdiom != .pad {
                        Button("Close") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
            // see comment for editMode @State above
            .environment(\.editMode, $editMode)
        }
    }
    
    var tap: some Gesture {
        TapGesture().onEnded { }
    }
}

struct PaletteManager_Previews: PreviewProvider {
    static var previews: some View {
        PaletteManager()
            .previewDevice("iPhone 8")
            .environmentObject(PaletteStore(named: "Preview"))
            .preferredColorScheme(.light)
    }
}
