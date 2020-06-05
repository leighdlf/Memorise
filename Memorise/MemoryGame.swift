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

struct MemoryGame<CardContent>  where CardContent: Equatable {
   
    // Only the model should be able to change/set this, but others (eg EmojiMemoryGame) should be able to read.
    private(set) var cards: Array<Card>
    
    // Gets the index of a card if it is the only one face up. Only model should be able to access.
    private var indexOfOneAndOnlyOneFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.only }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    // a2q8+9+a2Extra credit along with code in the choose() func. Display of score is in the view.
    private var timeOfLastCardPick: Date = Date()
    var score: Int = 0
    
    // if let makes this function do nothing if passed a nil.
    // , is a sequential &&. Used commonly with if let.
    mutating func choose(card: Card) {
        print("card chosen: \(card)")
        if let chosenIndex: Int = cards.firstIndex(matching: card), !self.cards[chosenIndex].isFaceUp, !self.cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfOneAndOnlyOneFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += max(5-Int(timeOfLastCardPick.timeIntervalSinceNow), 3) // TODO: Needs to be better.
                }
                self.cards[chosenIndex].isFaceUp = true
                score -= (score == 0 ? 0 : 1)
            } else {
                indexOfOneAndOnlyOneFaceUpCard = chosenIndex
                timeOfLastCardPick = Date()
            }
        }
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
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        // Reliable way for starting bonus time when isFaceUp changes.
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched: Bool = false {
            // This shouldn't reset during the game?
            didSet {
                stopUsingBonusTime()
            }
        }
        var content: CardContent // Don't care type.
        var id: Int
        
        
        // MARK: - Bonus Time
        
        // This could give matching bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up.
        
        // Can be zero which means "no bonus available" for the card.
        var bonusTimeLimit: TimeInterval = 6
        
        // How long this card has ever been face up.
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        //The last time the card was turned face up (and is still face up).
        var lastFaceUpDate: Date?
        // The accumulated time this card has been face up in the past.
        var pastFaceUpTime: TimeInterval = 0
        
        // How much time left before the bonus opportunity runs out.
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        // Percentage of the bonus time remaining.
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        
        // Wether the card was matched during the bonus time period.
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        
        // Wether we are currently face up, unmatched, and have not yet used up the bonus window.
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // Called when the card transitions to face up state.
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // Called when the card goes back face down (or gets matched).
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}
