//
//  FinalScore.swift
//  fortyFives
//
//  Created by Rich Ruais on 10/3/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.
//

import Foundation

struct FinalScore {
    var pair = 0
    var twoPair = 0
    var threeKind = 0
    var straight = 0
    var flush = 0
    var fullHouse = 0
    var fourKind = 0
    var straightFlush = 0
    var royalFlush = 0
    var totalPoints = 0
    var lifetimePoints = 0
    var bestScore = 0
}

struct Points {
    var pair = 10
    var twoPair = 20
    var threeKind = 25
    var straight = 30
    var flush = 35
    var fullHouse = 40
    var fourKind = 45
    var straightFlush = 50
    var royalFlush = 75
}
