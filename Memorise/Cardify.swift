//
//  Cardify.swift
//  Memorise
//
//  Created by Leigh De La Fontaine on 5/6/20.
//  Copyright © 2020 Leigh De La Fontaine. All rights reserved.
//

import SwiftUI

struct Cardify: ViewModifier {
    /// General cardifying view that can work on any View.
    
    var isFaceUp: Bool
    
    func body(content: Content) -> some View {
        // Takes in the given content and displays it on a card.
        ZStack {
            if isFaceUp {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: lineWidth)
                content
            } else {
                    RoundedRectangle(cornerRadius: cornerRadius).fill(
                        LinearGradient(gradient: Gradient(colors: [EmojiMemoryGame.themeColor, (EmojiMemoryGame.themeColor == .blue ? .red : .blue)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                ) // TODO: - Should move this fill somewhere else so it's more general.
                }
            }
        }
    
    private let cornerRadius: CGFloat = 10
    private let lineWidth: CGFloat = 3
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}

// iOS starts 0Degrees from the right. (0, 0) coordinates in iOS start in the top right (reverse clockwise/anti). From before cardify.
