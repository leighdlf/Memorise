//
//  Array+Identifiable.swift
//  Memorise
//
//  Created by Leigh De La Fontaine on 3/6/20.
//  Copyright © 2020 Leigh De La Fontaine. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable {
    /// Only adds too arrays that have elements that conform to the Identifiable protocol.
    /// Finds the first matching index of an array of the element.
    func firstIndex(matching: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == matching.id {
                return index
            }
        }
        return nil
    }
}
