//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Sergey Maslennikov on 24.11.2020.
//

import SwiftUI

/*
 MemoryGame 是真正的数据存储的地方, 是一个 Struct.
 EmojiMemoryGame 是 ViewModel. 是 Controller 层的东西. 它是一个 Class, 引用类型, 便于在各个 View 中共享, 便于生命周期的控制. s
 */
class EmojiMemoryGame: ObservableObject {
    /*
     @Published 是一个非常非常重要的属性.
     model.choose(card: card) 被调用, 修改了 MemoryGame 内部的数据. 而 MemoryGame 是一个 Struct, 所以它的 DidSet 的逻辑, 会被触发的.
     @Published 属性修饰, 会使得 ObservableObject 的 objectWillChange 信号被触发. 而 UI 部分, 是根据这个信号, 进行刷新动作的.
     
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
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    func resetGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}
