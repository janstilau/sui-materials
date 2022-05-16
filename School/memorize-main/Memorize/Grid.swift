//
//  Grid.swift
//  Memorize
//
//  Created by Sergey Maslennikov on 25.11.2020.
//

import SwiftUI

/*
 /// A proxy for access to the size and coordinate space (for anchor resolution) of the container view.
 public struct GeometryProxy {
     /// The size of the container view.
     public var size: CGSize { get }

     /// Resolves the value of `anchor` to the container view.
     public subscript<T>(anchor: Anchor<T>) -> T { get }

     /// The safe area inset of the container view.
     public var safeAreaInsets: EdgeInsets { get }

     /// Returns the container view's bounds rectangle, converted to a defined
     /// coordinate space.
     public func frame(in coordinateSpace: CoordinateSpace) -> CGRect
 }

 /// A container view that defines its content as a function of its own size and
 /// coordinate space.
 
 /// This view returns a flexible preferred size to its parent layout.
 @frozen public struct GeometryReader<Content> : View where Content : View {

     public var content: (GeometryProxy) -> Content

     @inlinable public init(@ViewBuilder content: @escaping (GeometryProxy) -> Content)

     /// The type of view representing the body of this view.
     ///
     /// When you create a custom view, Swift infers this type from your
     /// implementation of the required ``View/body-swift.property`` property.
     public typealias Body = Never
 }
 */

// 自己封装的一个 View.
// 就是将逻辑, 封装到自己的内部. 
struct Grid<Item, ItemView>: View where Item: Identifiable,
                                        ItemView: View {
    private var items: [Item]
    // 如何, 进行 ItemView 的生成, 暴露给外界了.
    // 生成什么样的类型, 也交给外界了.
    private var viewForItem: (Item) -> ItemView
    
    init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        // 根据, Layout 的值, 以及存储的 viewForItem 的值, 来算出到底应该如何进行展示.
        // GeometryReader 传出 Size 来, 很像是在 LayoutSubviews 里面, 进行布局的计算.
        // 其实也是这样的, 因为在 Body 其实在 Size 确定好之后, 进行
        GeometryReader { geometry in
            // 使用 ForEach 和 Frame, Position, 就是自己完全掌控布局的问题了.
            let layout = GridLayout(itemCount: self.items.count, in: geometry.size)
            ForEach(items) { item in
                self.createItemView(for: item, in: layout)
            }
        }
    }
    
    /*
     有这个 Position 这个 Modifier, 基本上, 之前的使用 Frame 进行绝对定位的要求是可以完成了.
     感觉有点像是在 LayoutSubviews 里面, 进行计算的逻辑一样.
     
     Position
     Positions the center of this view at the specified point in its parent’s coordinate space.
     
     func position(_ position: CGPoint) -> some View
     
     Use the position(_:) modifier to place the center of a view at a specific coordinate in the parent view using a CGPoint to specify the x and y offset.
     
     Text("Position by passing a CGPoint()")
     .position(CGPoint(x: 175, y: 100))
     .border(Color.gray)
     
     position
     The point at which to place the center of this view.
     Returns
     
     A view that fixes the center of this view at position.
     */
    private func createItemView(for item: Item, in layout: GridLayout) -> some View {
        let index = items.firstIndex(matching: item)!
        return viewForItem(item)
            .frame(width: layout.itemSize.width, height: layout.itemSize.height)
            .position(layout.location(ofItemAt: index))
    }
}
