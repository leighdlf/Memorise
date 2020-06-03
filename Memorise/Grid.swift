//
//  Grid.swift
//  Memorise
//
//  Created by Leigh De La Fontaine on 2/6/20.
//  Copyright © 2020 Leigh De La Fontaine. All rights reserved.
//

// Can be used in all apps that need a grid.
// @escaping if for items not used/assigned now but later. Needs to be around for the future. Function types now references types. Lives/makes sure its in the heap?

import SwiftUI

struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {  // Care a little bit. Protocols so generics can work, connect them.
    var items: [Item]
    var viewForItem: (Item) -> ItemView
    
    init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.viewForItem = viewForItem
    }
    
    // How much space given to the grid. Divides up space to its children. How much space is given to.
    var body: some View {
        GeometryReader { geometry in
            self.body(for: GridLayout(itemCount: self.items.count, in: geometry.size))
        }
    }
    
    // Divide the space given amongst the child elements
    // Trick to overcome self. in geometry reader. Just pass geometry.size not whole body. Same is in EmojiMemoryGameView.
    func body(for layout: GridLayout) -> some View {
        ForEach(items) { item in
            self.body(for: item, in: layout)
        }
    }
    
    // Offer the space the the children. Then position them in the grid layout.
    func body(for item: Item, in layout: GridLayout) -> some View {
        let index = items.firstIndex(matching: item)!   // Immediately force unwrapps, turns index into an Int. Look into Grid and ViewBuilder from lecture 4.
        return viewForItem(item)
            .frame(width: layout.itemSize.width, height: layout.itemSize.height)
            .position(layout.location(ofItemAt: index))
    }
}


