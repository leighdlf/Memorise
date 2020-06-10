//
//  Cardify.swift
//  Memorise
//
//  Created by Leigh De La Fontaine on 5/6/20.
//  Copyright © 2020 Leigh De La Fontaine. All rights reserved.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    /// General cardifying view that can work on any View.
    
    // Rotation in degrees
    var rotation: Double
    
    init(isFaceUp: Bool) {
        // Shows the face when it's note face up, rotates to the back otherwise.
        rotation = isFaceUp ? 0 : 180
    }
    
    var isFaceUp: Bool {
        rotation < 90
    }
    
    var animatableData: Double {
        // Double is rotation
        // Computed property to effectively rename this too rotation. Ref lecture 6.
        get { return rotation }
        set { rotation = newValue }
    }
    
    func body(content: Content) -> some View {
        // Takes in the given content and displays it on a card.
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: lineWidth)
                content
            }
            .opacity(isFaceUp ? 1 : 0)  // Cards are never removed from screen, just hidden.
            RoundedRectangle(cornerRadius: cornerRadius).fill(
                LinearGradient(gradient: Gradient(colors: [EmojiMemoryGame.themeColor, (EmojiMemoryGame.themeColor == .blue ? .red : .blue)]), startPoint: .topLeading, endPoint: .bottomTrailing)) // TODO: - Should move this fill somewhere else.
                .opacity(isFaceUp ? 0 : 1)  // Wan' the card coming or going or not?
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0,1,0))
    }
    
    private let cornerRadius: CGFloat = 10
    private let lineWidth: CGFloat = 3
}

extension View {
    /// Extends View so that you can call Cardify with .cardify.
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}

// iOS starts 0Degrees from the right. (0, 0) coordinates in iOS start in the top right (reverse clockwise/anti). From before cardify.
