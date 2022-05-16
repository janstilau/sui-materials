//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Sergey Maslennikov on 23.11.2020.
//

import SwiftUI

/*
 
 /// A view that arranges its children in a vertical line.
 
 /// Unlike ``LazyVStack``, which only renders the views when your app needs to
 /// display them onscreen, a `VStack` renders the views all at once, regardless
 /// of whether they are on- or offscreen. Use the regular `VStack` when you have
 /// a small number of child views or don't want the delayed rendering behavior
 /// of the "lazy" version.
 ///
 /// The following example shows a simple vertical stack of 10 text views:
 ///
 ///     var body: some View {
 ///         VStack(
 ///             alignment: .leading,
 ///             spacing: 10
 ///         ) {
 ///             ForEach(
 ///                 1...10,
 ///                 id: \.self
 ///             ) {
 ///                 Text("Item \($0)")
 ///             }
 ///         }
 ///     }
 ///
 /// ![Ten text views, named Item 1 through Item 10, arranged in a
 /// vertical line.](SwiftUI-VStack-simple.png)
 ///
 @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
 @frozen public struct VStack<Content> : View where Content : View {

     /// Creates an instance with the given spacing and horizontal alignment.
     ///
     /// - Parameters:
     ///   - alignment: The guide for aligning the subviews in this stack. This
     ///     guide has the same vertical screen coordinate for every child view.
     ///   - spacing: The distance between adjacent subviews, or `nil` if you
     ///     want the stack to choose a default distance for each pair of
     ///     subviews.
     ///   - content: A view builder that creates the content of this stack.
     @inlinable public init(alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> Content)

     /// The type of view representing the body of this view.
     ///
     /// When you create a custom view, Swift infers this type from your
     /// implementation of the required ``View/body-swift.property`` property.
     public typealias Body = Never
 }
 */

struct EmojiMemoryGameView: View {
    // Size is 16
    // 任何, ViewModel 的修改, 都会导致信号的发送, View 中可以检测这个信号, 然后进行重绘.
    @ObservedObject var viewModel: EmojiMemoryGame
    
    /*
     实际上, Body 返回的是这样一个类型.
     VStack<TupleView<(ModifiedContent<HStack<TupleView<(Button<Text>, Text)>>, _PaddingLayout>, ModifiedContent<ModifiedContent<Grid<Card, ModifiedContent<ModifiedContent<CardView, AddGestureModifier<_EndedGesture<TapGesture>>>, _PaddingLayout>>, _PaddingLayout>, _EnvironmentKeyWritingModifier<Optional<Color>>>)>>
     
     这是一个计算属性, 它并不占据 EmojiMemoryGameView 的存储空间的.
     */
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // 明确显示动画.
                    withAnimation(.easeInOut) {
                        // 在 ViewAction 里面, 调用 ViewModel 的 ModelAction.
                        // ModelAction 修改数据, 然后触发 Viw 的修改.
                        self.viewModel.resetGame()
                    }
                }, label: { Text("New Game").size()})
                Text("Flips: 0")
            }.size().padding(.top)
            
            Grid(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    withAnimation(.linear(duration: 0.5)) {
                        self.viewModel.choose(card: card)
                    }
                }.size()
                .padding(5).size()
            }
            .padding()
            .foregroundColor(Color.orange)
        }
    }
}

struct MyView: View {
    var body: some View {
        Text("12").size()
    }
}

struct CardView: View {
    // 数据 Model.
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    // allowing those closures to provide multiple child views 允许闭包中提供多个子视图
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaining*360-90), clockwise: true)
                            .onAppear {
                                self.startBonusTimeAnimation()
                            }
                    } else {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-card.bonusRemaining*360-90), clockwise: true)
                    }
                }
                .padding(5).opacity(0.4)
                .transition(.identity)
                Text(card.content)
                    .font(Font.system(size: fontSize(for: size)))
//                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
//                    .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
            }
            .cardify(isFaceUp: card.isFaceUp)
            .transition(AnyTransition.scale)
        }
    }
    
    // MARK: - Drawing Constants
    
    
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7
    }
}








//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let game = EmojiMemoryGame()
//        game.choose(card: game.cards[0])
//        return EmojiMemoryGameView(viewModel: game)
//    }
//}
