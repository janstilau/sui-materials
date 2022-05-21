import SwiftUI

struct AsyncImage<Placeholder: View>: View {
    
    // 该 View 的 ViewModel 类.
    /*
     在出现的时候, 触发 ViewModel 的取值操作.
     在结束的时候, 取消 ViewModel 的取值操作.
     
     ViewModel 的信号变化, 触发整个 View 的信号变化.
     */
    @ObservedObject private var imgLoader: ImageLoader
    
    private let placeholder: Placeholder?
    private let configuration: (Image) -> Image
    
    init(url: URL, cache: ImageCache? = nil, placeholder: Placeholder? = nil, configuration: @escaping (Image) -> Image = { $0 }) {
        // 在构造的时候, 构造一下 loader 类, 真实真正的进行网络存储的地方 .
        imgLoader = ImageLoader(url: url, cache: cache)
        self.placeholder = placeholder
        self.configuration = configuration
    }
    
    // 和之前才想的一样, Swfit 中, 各种 View 就是进行信息的收集工作 .'
    // 将各种相应的时机应该触发的逻辑, 使用回调进行触发.
    var body: some View {
        image
        // Adds an action to perform when this view appears.
            .onAppear(perform: imgLoader.load)
        // Adds an action to perform when this view disappears.
            .onDisappear(perform: imgLoader.cancel)
    }
    
    // 大量大量, 使用了计算属性的方式, 在 Body 里面进行创建.
    private var image: some View {
        // 之所以, 要使用 Group, 是因为后面的 onAppear, onDisappear 想要都发挥作用.
        Group {
            if imgLoader.image != nil {
                configuration(Image(uiImage: imgLoader.image!))
            } else {
                placeholder
            }
        }
    }
}

