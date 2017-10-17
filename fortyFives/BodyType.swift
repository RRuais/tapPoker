//
//  BodyType.swift
//  fortyFives
//
//  Created by Rich Ruais on 9/30/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.
//

import Foundation
import UIKit

struct BodyType {
    static let none: UInt32 = 0
    static let bottomScreen: UInt32 = 0b1 // 1
    static let card: UInt32 = 0b10 // 2
    static let freeCardBall: UInt32 = 0b100 // 4
    static let addTimeBall: UInt32 = 0b0110 // 6
    static let all: UInt32 = UInt32.max
}
