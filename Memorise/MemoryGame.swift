//
//  MemoryGame.swift
//  Memorise
//
//  Created by Leigh De La Fontaine on 1/6/20.
//  Copyright © 2020 Leigh De La Fontaine. All rights reserved.
//


// This is the model. UI independent; doesn't know how the display works.
// strucs are always copied. arg to functions become constants.

import Foundation

// Nesting structs inside strucs is generally a name-spacing thing.
// CardContent is a 'don't care'. Whoever creates this needs to provide the content (eg EmojiGameModel).
// self. might eventually not be needed but safe to use it most of the time.
// var cards: Array<Card> is uninitialised, must be passed a value when the struct is.
// therefore in func choose we flip the cards flips the card directly in the array. In structs only mutating funcs can change self.

struct MemoryGame<CardContent> {
    var cards: Array<Card>
    
    mutating func choose(card: Card) {
        print("card chosen: \(card)")
        let chosenIndex: Int = self.index(of: card)
        self.cards[chosenIndex].isFaceUp = !self.cards[chosenIndex].isFaceUp
    }
    
    func index(of card: Card) -> Int {
        for index in 0..<self.cards.count {
            if self.cards[index].id == card.id {
                return index
            }
        }
        return 0 // TODO: bogus! Needs to be fixed. What to be returned if nothing is found??
    }
    
    // Can have multiple ways of initialising.
    // Cards is initialised as an empty array.
    // Takes in the number of pairs of cards to create, and a func that creates the cards contents.
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in  0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        // for a1q2. Done here instead of view as no real logic should happen there, only display what it's told.
        // was originally done on model.cards in EmojiMemoryGameView but that caused a big that would shuffle the screen whenever a card was selected.
        self.cards = cards.shuffled()
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        var content: CardContent // Don't care type.
        var id: Int
    }
}
