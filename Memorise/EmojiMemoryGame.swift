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
// private(set) isn't used. Access to model is done through a var?. Allows view model to interpret data (maybe process it).
// Intents (like func choose()) allows views tell the model what it wants to do/happen?
// ObservableObject is another protocol.
// Protocols formalise how data structures behave; there functionality only.
// @Published calls objectWillChange.send() when a model changes for each function. objectWillChange.send() can be added to func/intents if wanted/needed

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String> {
        let emojis: Array<String> = ["👻", "🎃", "🕷", "😈", "😱", "🙀", "🧙‍♂️", "🐱", "🍭", "🧚🏿‍♀️", "👹", "👺"].shuffled() // a1 extra credit
        // Int.random() for a1q4
        return MemoryGame<String>(numberOfPairsOfCards: Int.random(in: 2...5)) { pairIndex in
            return emojis[pairIndex] }
    }
        
    // Added by ObserableObject. Has func objectWillChange.send. Notifies things interested when model changes. Is hidden; don't need to add.
    // Therefore views looking at this model will update themselves.
//    var objectWillChange: ObservableObjectPublisher
    
    // MARK: - Access to the model.
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards.shuffled() // for a1q2. Done here instead of view as no real logic should happen there, only display what it's told.
    }
    
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
}
