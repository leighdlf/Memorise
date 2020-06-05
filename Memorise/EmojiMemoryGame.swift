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
// Protocols formalise how data structures behave; they're functionality only.
// @Published calls objectWillChange.send() when a model changes for each function. objectWillChange.send() can be added to func/intents if wanted/needed

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    // Default values
    static var themeColor = Color.blue
    static var themeName = ""
    
    // don't want the view from being able to call this function directly.
    private static func createMemoryGame() -> MemoryGame<String> {
        let theme = setGameTheme(theme: EmojiGameThemes.allCases.randomElement()!)
        themeColor = theme.color
        themeName = theme.name
        // .shuffled() a1 extra credit
        let emojis = theme.emojis.shuffled()
        
        // Int.random() for a1q4
        return MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairsOfCards) { pairIndex in
            return emojis[pairIndex] }
    }
    
    // a2q3. 
    enum EmojiGameThemes: CaseIterable {
        case halloween, sports, animals, faces, flags, food
    }

    static func setGameTheme(theme: EmojiGameThemes) -> (name: String, emojis: Array<String>, numberOfPairsOfCards: Int, color: Color) {
        switch theme {
        case .halloween:
            return ("Halloween", ["👻", "🎃", "🕷", "😈", "😱", "🙀", "🧙‍♂️", "🏚", "🍭", "🧚🏿‍♀️", "👹", "👺"], Int.random(in: 2...5), Color.orange)
        case .sports:
            return ("Sports", ["⚽️", "🏏", "🏀", "🏈", "⚾️", "🏓", "🏒", "🎱", "🎳", "🏹", "🏸", "⛳️"], Int.random(in: 2...5), Color.blue)
        case .animals:
            return ("Animals", ["🐶", "🐱", "🦁", "🐭", "🦊", "🐰", "🐼", "🐮", "🐸", "🐨", "🐵", "🐷"], Int.random(in: 2...5), Color.pink)
        case .faces:
            return ("Faces", ["😀", "😩", "😭", "😡", "🥶", "😇", "😅", "🤣", "😨", "😐", "🙄", "🥴"], Int.random(in: 2...5), Color.yellow)
        case .flags:
            return ("Flags", ["🇦🇺", "🇺🇸", "🇬🇧", "🇨🇦", "🇮🇪", "🇳🇿", "🇿🇦", "🇯🇵", "🇨🇳", "🇲🇽", "🇮🇳", "🇧🇩"], 3, Color.gray)
        case .food:
            return ("Fruit", ["🍎", "🍌", "🍊", "🥭", "🍒", "🍑", "🍐", "🍋", "🍍", "🥝", "🍓", "🍇"], Int.random(in: 2...5), Color.green)
        }
    }

        
    // Added by ObservableObject. Has func objectWillChange.send. Notifies things interested when model changes. Is hidden; don't need to add.
    // Therefore views looking at this model will update themselves.
//    var objectWillChange: ObservableObjectPublisher
    
    // MARK: - Access to the model.
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    var score: Int {
        model.score
    }
    
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    // a2q6 with the button in the view model.
    func newGame() {
        self.model = EmojiMemoryGame.createMemoryGame()
    }
}
