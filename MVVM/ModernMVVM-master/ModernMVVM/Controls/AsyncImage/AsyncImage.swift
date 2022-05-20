
import SwiftUI

struct AsyncImage<Placeholder: View>: View {
    
    @ObservedObject private var loader: ImageLoader
    
    private let placeholder: Placeholder?
    private let configuration: (Image) -> Image
    
    init(url: URL, cache: ImageCache? = nil, placeholder: Placeholder? = nil, configuration: @escaping (Image) -> Image = { $0 }) {
        // 在构造的时候, 构造一下 loader 类,
        loader = ImageLoader(url: url, cache: cache)
        self.placeholder = placeholder
        self.configuration = configuration
    }
    
    // 和之前才想的一样, Swfit 中, 各种 View 就是进行信息的收集工作 .'
    // 将各种相应的时机应该触发的逻辑, 使用回调进行触发.
    var body: some View {
        image
        // Adds an action to perform when this view appears.
            .onAppear(perform: loader.load)
        // Adds an action to perform when this view disappears.
            .onDisappear(perform: loader.cancel)
    }
    
    // 大量大量, 使用了计算属性的方式, 在 Body 里面进行创建.
    private var image: some View {
        // 之所以, 要使用 Group, 是因为后面的 onAppear, onDisappear 想要都发挥作用.
        Group {
            if loader.image != nil {
                configuration(Image(uiImage: loader.image!))
            } else {
                placeholder
            }
        }
    }
}

/*
 Group
 A type that collects multiple instances of a content type — like views, scenes, or commands — into a single unit.
 
 Use a group to collect multiple views into a single instance, without affecting the layout of those views, like an HStack, VStack, or Section would. After creating a group, any modifier you apply to the group affects all of that group’s members. For example, the following code applies the headline font to three views in a group.

 Group {
     Text("SwiftUI")
     Text("Combine")
     Text("Swift System")
 }
 .font(.headline)
 Because you create a group of views with a ViewBuilder, you can use the group’s initializer to produce different kinds of views from a conditional, and then optionally apply modifiers to them. The following example uses a Group to add a navigation bar title, regardless of the type of view the conditional produces:

 Group {
     if isLoggedIn {
         WelcomeView()
     } else {
         LoginView()
     }
 }
 .navigationBarTitle("Start")
 The modifier applies to all members of the group — and not to the group itself. For example, if you apply onAppear(perform:) to the above group, it applies to all of the views produced by the if isLoggedIn conditional, and it executes every time isLoggedIn changes.

 Because a group of views itself is a view, you can compose a group within other view builders, including nesting within other groups. This allows you to add large numbers of views to different view builder containers. The following example uses a Group to collect 10 Text instances, meaning that the vertical stack’s view builder returns only two views — the group, plus an additional Text:

 var body: some View {
     VStack {
         Group {
             Text("1")
             Text("2")
             Text("3")
             Text("4")
             Text("5")
             Text("6")
             Text("7")
             Text("8")
             Text("9")
             Text("10")
         }
         Text("11")
     }
 }
 You can initialize groups with several types other than View, such as Scene and ToolbarContent. The closure you provide to the group initializer uses the corresponding builder type (SceneBuilder, ToolbarContentBuilder, and so on), and the capabilities of these builders vary between types. For example, you can use groups to return large numbers of scenes or toolbar content instances, but not to return different scenes or toolbar content based on conditionals
 */
