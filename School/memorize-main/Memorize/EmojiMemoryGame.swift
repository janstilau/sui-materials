//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Sergey Maslennikov on 24.11.2020.
//

import SwiftUI

/*
 整个 App 的 ViewModel 是由 MemoryGame 来控制的.
 在其内部, 存储了所需要的状态值. 并且提供了各种 ModelAction 接口, 来应对 ViewAction.
 */
class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    private static func createMemoryGame() -> MemoryGame<String> {
        let emojisAll: Array<String> = ["🧠","🧟‍♀️","🧛‍♂️","🧵","🧶","🎓","🧳","🐶","🦊","🐯","🦁","🐵","🐸","🐮","🐷","🐼","🐨","🐰","🐹","🦉","🦆","🐔","🐗","🐺","🦇","🦄","🐴","🐌","🦋","🐝","🐞","🦕","🦖","🐢","🐙","🦐","😄","😎","🤓","💩","🎃","👣","🦷","🐬","🐳","🐟","🐠","🐡","🦈","🐊","🦧","🐘","🐫","🐾","🦥","🦦","🦨","🌵","🎄","🌴","👻","🍂","🌹","🌸","🌼","⭐️","🌍","🔥","☃️","🍏","🍎","🥥","🥩","🧀","🍗","🍤","🥟","🍿","🎂","🍪","🍩","🧁","⚽️","🏀","🏈","🏆","🎲","🚕","✈️","🚀","🗿","🌋","💰","💎","💊","🧼","🦠","🎁","📦"]
        let emojis = emojisAll[randomPick: 9]
        // emojis.count = 9
        return MemoryGame<String>(numberOfPairsOfCards: emojis.count) { pairIndex in
            return emojis[pairIndex]
        }
    }
    
    // MARK: - Access to the Model
    
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
