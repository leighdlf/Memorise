//
//  EmojiMemoryGame.swift
//  Memorise
//
//  Created by Leigh De La Fontaine on 1/6/20.
//  Copyright © 2020 Leigh De La Fontaine. All rights reserved.
//

// View model. Glue/portal between model and view.
// Class instead of struct as many views will have pointers to it/use as portal.
// EmojiMemoryGame because its a type of MemoryGame that draws emojis
// Imports SwiftUI as instead of Foundation as it knows how things will be drawn.
// Don't call EmojiMemoryGame var model, use something like game instead.
// MemoryGame type is String as that what emojis are.
// private(set) allows others to see but only EmojiMemoryGame chan modify it. Don't want others being able to change the model.
// private(set) isn't used. Access to model is done. Allows Views to interpret data (maybe process it).
// Intents (like func choose()) allows views tell the model what it wants to do/happen?

import SwiftUI


class EmojiMemoryGame {
    private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String> {
        let emojis: Array<String> = ["👻", "🎃", "🕷"]
        return MemoryGame<String>(numberOfPairsOfCards: emojis.count) { pairIndex in
            return emojis[pairIndex] }
    }
        
    
    
    // MARK: - Access to the model.
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
}
