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
struct ContentView: View {
    var body: some View {
        HStack {
            ForEach(0..<4) { index in
                CardView(isFaceUp: true)
            }
        }
            .padding()
            .foregroundColor(Color.orange)
            .font(Font.largeTitle)
    }
}


// Factored out of encapsulation; out of HStack { ForEach }
// isFaceUp has needs to be initialised when called.
struct CardView: View {
    var isFaceUp: Bool
    
    var body: some View {
        ZStack { if isFaceUp {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
                Text("👻")
            } else {
                RoundedRectangle(cornerRadius: 10.0).fill()
            }
        }
    }
}

// Connects to canvas preview.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
