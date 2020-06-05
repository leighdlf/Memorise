//
//  EmojiMemoryGameView.swift
//  Memorise
//
//  Created by Leigh De La Fontaine on 1/6/20.
//  Copyright © 2020 Leigh De La Fontaine. All rights reserved.
//

import SwiftUI

// EmojiMemoryGameView 'behaves' like a view. The rectangle of this view is the entire screen.
// View is a protocol. 'Constrains and gains'.
// var body is a property. some View type is any type that behaves like a view.
// Each some View can only contain the same type of view. ie some is singular.
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

// Cant create var in view builder (eg HStack), can be put in the var body, or better as a computed value in the struct.
// @ObservedObject says a var has an observable object in it. SwiftUI is smart and will only redraw the what is required; card changed.
// @ObservedObject and @Published allows for reactive programming.

// ZStack is a view builder or from one?

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame  // Can't be private as SceneDelegate calls it.
    
    var body: some View {
        VStack(alignment: .center) {
            // a2q7
            Text("\(EmojiMemoryGame.themeName) Cards")
                .font(Font.largeTitle)
                .bold()
            Text("Score: \(viewModel.score)")
                .font(Font.title)
            
            Divider()
            
            Grid(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    self.viewModel.choose(card: card)
                }
                .padding(5)
            }
            .padding()
            .foregroundColor(EmojiMemoryGame.themeColor)
            
            Button(action: {
                self.viewModel.newGame()
            }) {
                Text("New Game")
                    .fontWeight(.bold)
                    .padding()
                    // a2 extra credit for the gradient.
                    .background(Capsule().fill(
                        LinearGradient(gradient: Gradient(colors: [EmojiMemoryGame.themeColor, (EmojiMemoryGame.themeColor == .blue ? .red : .blue)]), startPoint: .topLeading, endPoint: .bottomTrailing)))
                    .foregroundColor(Color.white)
            }
        }
    }
}


// Factored out of encapsulation; out of HStack { ForEach }
// isFaceUp has needs to be initialised when called.
struct CardView: View {
    var card: MemoryGame<String>.Card   // Cant be private as it called and set in grid view.
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    // Trick to overcome self. in geometry reader. Just pass geometry.size not whole body. Helper func.
    // Look how it was originally done and changed in lecture 3.
    // All Stack take ViewBuilder? Turns something into some View??
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {   // ViewBuilder means it's a list of views, which can be empty if this is false.
            ZStack {
                Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(110-90), clockWise: true).padding(5).opacity(0.4)
                Text(self.card.content)
                    .font(Font.system(size: fontSize(for: size)))
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    // Mark: - Drawing Constants
    // Fixes 'magic numbers'.
    // CGFloat needs to defined to get over type inference.
    
    private let fontScalingFactor: CGFloat = 0.75
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7 // Sets its own font, better for encapsulation. One liner function is good for simplicity, as sometimes needed
    }
}

// Connects to canvas preview. Only used for development. Creates an EmojiMemoryGame on the fly? Preview doesn't use SceneDelegate?
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
    }
}
