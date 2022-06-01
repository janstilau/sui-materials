//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Sergey Maslennikov on 24.11.2020.
//

import SwiftUI

/*
 MemoryGame 是真正的数据存储的地方, 是一个 Struct.
 EmojiMemoryGame 是 ViewModel. 是 Controller 层的东西. 它是一个 Class, 引用类型, 便于在各个 View 中共享, 便于生命周期的控制.
 可以看到, ViewModel 不一定是 ViewModel.
 最最主要的是, 认清楚这是一个 Controller 层的东西. 这样, 很多的代码, 写到里面, 也就不感觉乱了.
 */
class EmojiMemoryGame: ObservableObject {
    /*
     @Published 是一个非常非常重要的属性.
     model.choose(card: card) 被调用, 修改了 MemoryGame 内部的数据.
     model 的 didSet, 因为被 @Published 修饰, 所以实际内部是调用对应的 Subject 的 send 方法, 在这个 Subject 的 Send 方法内部, 会触发 objectWillChange 信号的发出.
     如果, 把 @Published 注释掉, 那么整个 UI 刷新就不起作用了.
     */
    @Published
    private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    private static func createMemoryGame() -> MemoryGame<String> {
        let emojisAll: Array<String> = ["🧠","🧟‍♀️","🧛‍♂️","🧵","🧶","🎓","🧳","🐶","🦊","🐯","🦁","🐵","🐸","🐮","🐷","🐼","🐨","🐰","🐹","🦉","🦆","🐔","🐗","🐺","🦇","🦄","🐴","🐌","🦋","🐝","🐞","🦕","🦖","🐢","🐙","🦐","😄","😎","🤓","💩","🎃","👣","🦷","🐬","🐳","🐟","🐠","🐡","🦈","🐊","🦧","🐘","🐫","🐾","🦥","🦦","🦨","🌵","🎄","🌴","👻","🍂","🌹","🌸","🌼","⭐️","🌍","🔥","☃️","🍏","🍎","🥥","🥩","🧀","🍗","🍤","🥟","🍿","🎂","🍪","🍩","🧁","⚽️","🏀","🏈","🏆","🎲","🚕","✈️","🚀","🗿","🌋","💰","💎","💊","🧼","🦠","🎁","📦"]
        let emojis = emojisAll[randomPick: 9]
        // emojis.count = 9
        return MemoryGame<String>(numberOfPairsOfCards: emojis.count) { pairIndex in
            return emojis[pairIndex]
        }
    }
    
    // MARK: - Access to the Model
    // 整个 View 需要的数据, 是通过复制 Model 的数据得到的.
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    // MARK: - Intent(s)
    // ViewModel 直接和 View 进行对接, 来处理 ViewAction. 而不是将真正的 Model 暴露出去.
    // ViewModel 是 Controller 层, Controller 的协调者, 在 MVVM 中其实没有丢失.
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    func resetGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}
