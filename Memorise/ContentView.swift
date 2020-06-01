//
//  ContentView.swift
//  Memorise
//
//  Created by Leigh De La Fontaine on 1/6/20.
//  Copyright © 2020 Leigh De La Fontaine. All rights reserved.
//

import SwiftUI

// ContentView 'behaves' like a view. The rectangle of this view is the entire screen.
// var body is a property. some View type is any type that behaves like a view.
// Think of views like legos. They can be put together. ZStack is a combiner view
// return isn't needed in one liners.
// Text also behaves like a view.
// Having modifiers on ZStack scopes it; applies to all.
// padding applies to entire ZStack, foregroundColor to its children.
// index is iteration var. ForEach isn't layout like ZStack.
// Padding and spacing(in stacks) is generally kept standard.
// if nor args then () can be removed, if last arg is {} cat sit outside.
// Like model, you wouldn't use viewModel as a name.
// viewModel is a pointer to the EmojiMemoryGame. It is created in the SceneDelegate file?

struct ContentView: View {
    var viewModel: EmojiMemoryGame
    
    var body: some View {
        HStack {
            ForEach(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    self.viewModel.choose(card: card)
                }
            }
        }
            .padding()
            .foregroundColor(Color.orange)
            .font(viewModel.cards.count < 10 ? Font.largeTitle : Font.title) // a1q5
    }
}


// Factored out of encapsulation; out of HStack { ForEach }
// isFaceUp has needs to be initialised when called.
struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        ZStack {
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
                Text(card.content)
            } else {
                RoundedRectangle(cornerRadius: 10.0).fill()
            }
        }.aspectRatio(2/3, contentMode: .fit) // a1q3

    }
}

// Connects to canvas preview. Only used for development. Creates an EmojiMemoryGame on the fly?
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: EmojiMemoryGame())
    }
}
