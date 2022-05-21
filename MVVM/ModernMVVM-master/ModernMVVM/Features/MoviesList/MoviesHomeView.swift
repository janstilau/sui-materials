//
//  MoviesListView.swift
//  ModernMVVM
//
//  Created by Vadym Bulavin on 2/20/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import Combine
import SwiftUI

struct MoviesHomeView: View {
    @ObservedObject var viewModel: MoviesHomeViewModel
        
    var body: some View {
        NavigationView {
            let value = content
            /*
             SwiftUI.AnyView
             */
            value.navigationBarTitle("Trending Movies")
        }
        // SwiftUI 的 View 文件, 起到的就是 ViewController 的作用.
        // 不过这里没有 ViewController 的 TemplateMethod 的使用. 所以, 在 Swift UI 里面, 通过 ViewModifier 将各种应该处理的逻辑, 使用 Block 的方式进行了存储.
        // 对于 Swfit UI 的 View 来说, 这个 Body 中的内容, 只是进行信息的收集而已.
        
        // Adds an action to perform when this view appears.
        // 在 ViewController 的特定时机, 来调用 ViewModel 的 Intent 方法, 也可以看做是 ViewAction -> ViewModel.IntentAction 的触发.
        .onAppear { self.viewModel.send(event: .onAppear) }
    }
    
    // 真正的内容, 封装到了 Content 这个计算属性里面.
    // 每次, ViewModel 的 state 更改了之后, 就会触发 Body 重新调用, 触发 View 的重新刷新.
    private var content: some View {
        /*
         当, 把 eraseToAnyView 删除了只有, 就会调用下面的错误.
         这是因为, someView 其实要确定类型的.
         Function declares an opaque return type, but the return statements in its body do not have matching underlying types
         
         当, 都添加了 eraseToAnyView 之后.
         SwiftUI.AnyView
         */
        switch viewModel.state {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading:
            return Spinner(isAnimating: true, style: .large).eraseToAnyView()
        case .error(let error):
            return Text(error.localizedDescription).eraseToAnyView()
        case .loaded(let movies):
            return list(of: movies).eraseToAnyView()
        }
    }
    
    private func list(of movies: [MoviesHomeViewModel.ListItem]) -> some View {
        List(movies) { movie in
            NavigationLink(
                destination: MovieDetailView(viewModel: MovieDetailViewModel(movieID: movie.id)),
                label: { MovieListItemView(movie: movie) }
            )
        }
    }
}

struct MovieListItemView: View {
    let movie: MoviesHomeViewModel.ListItem
    // 使用了 @Environment 这个技术, 进行了对应的 Service 的获取.
    @Environment(\.imageCache) var cache: ImageCache

    var body: some View {
        VStack {
            title
            poster
        }
    }
    
    // 其实, 在 SwiftUI 里面, 各种 Compute Value 就是 setup Subview 的各种方法的调用了.
    private var title: some View {
        Text(movie.title)
            .font(.title)
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }
    
    private var poster: some View {
        let value =
        movie.poster.map { url in
            AsyncImage(
                url: url,
                cache: cache,
                placeholder: spinner,
                configuration: { $0.resizable().renderingMode(.original) }
            )
        }
        .aspectRatio(contentMode: .fit)
        // 这里固定好了尺寸的值.
        .frame(idealHeight: UIScreen.main.bounds.width / 2 * 3) // 2:3 aspect ratio
        
        // ModifiedContent<ModifiedContent<Optional<AsyncImage<Spinner>>, _AspectRatioLayout>, _FlexFrameLayout>
        // <Optional<AsyncImage<Spinner>>, _AspectRatioLayout>
        print(type(of: value))
        
        return value
    }
    
    private var spinner: some View {
        Spinner(isAnimating: true, style: .medium)
    }
}
