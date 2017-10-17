//
//  PlayingCard.swift
//  fortyFives
//
//  Created by Rich Ruais on 9/26/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.
//

import Foundation

struct Card {
    let suit: String
    let rank: String
    let value: Int
    let imageName: String
}

extension Card: Equatable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return
            lhs.suit == rhs.suit && lhs.rank == rhs.rank && lhs.value == rhs.value && lhs.imageName == rhs.imageName
    }
}

class PlayingCard {
    let suits = ["clubs", "spades", "hearts", "diamonds"]
    let ranks = ["ace", "2", "3", "4", "5", "6", "7", "8", "9", "10", "jack", "queen", "king"]
    let values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
    
    func createDeck() -> [Card] {
        var newDeck = [Card]()
        for suit in suits {
            for i in 0..<values.count {
                let imageName = "\(ranks[i])_of_\(suit)"
                let newCard = Card.init(suit: suit, rank: ranks[i], value: values[i], imageName: imageName)
                newDeck.append(newCard)
            }
        }
        return newDeck
    }
    
    func shuffleDeck(deck: [Card]) -> [Card] {
        var newDeck = deck
        for card in newDeck {
            let randNum: Int = randomIndexForArray(array: newDeck)
            let tempCard = card
            let index = newDeck.index(of: card)
            newDeck.remove(at: index!)
            newDeck.insert(tempCard, at: randNum)
        }
        return newDeck
    }
}


