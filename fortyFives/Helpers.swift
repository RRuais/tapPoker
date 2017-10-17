//
//  Helpers.swift
//  fortyFives
//
//  Created by Rich Ruais on 9/29/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.
//

import Foundation


public func randomIndexForArray(array: [Any]) -> Int {
    return Int(arc4random_uniform(UInt32(array.count)))
}

public func randomIntFrom(start: Int, to end: Int) -> Int {
    var a = start
    var b = end
    // swap to prevent negative integer crashes
    if a > b {
        swap(&a, &b)
    }
    return Int(arc4random_uniform(UInt32(b - a + 1))) + a
}

