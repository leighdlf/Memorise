//
//  Array+Only.swift
//  Memorise
//
//  Created by Leigh De La Fontaine on 3/6/20.
//  Copyright © 2020 Leigh De La Fontaine. All rights reserved.
//

import Foundation

/// Returns the element of an Array if that Array contains a single element.
extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
