//
//  MemoryGame.swift
//  Memorise
//
//  Created by Leigh De La Fontaine on 1/6/20.
//  Copyright © 2020 Leigh De La Fontaine. All rights reserved.
//

//This is the model. UI independent; doesn't know how the display works.

import Foundation

// Nesting structs inside strucs is generally a namespacing thing.
// CardContent is a 'don't care'
// var cards: Array<Card> is uninitialised, must be passed a value when the struct is.

struct MemoryGame<CardContent> {
    var cards: Array<Card>
    
    func choose(card: Card) {
        print("card chosen: \(card)")
    }
    
    // Can have multiple ways of initialising.
    // Cards is initialised as an empty array.
    // Takes in the number of pairs of cards to create, and a func that creates the cards contents
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in  0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        var content: CardContent // Don't care type.
        var id: Int
    }
}
