//
//  GameLogic.swift
//  fortyFives
//
//  Created by Rich Ruais on 9/27/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.
//

import Foundation

class GameLogic {
    
    let playingCard = PlayingCard()
    var deck = [Card]()
    var hand = [Card]()
    var answerNumber = 0
    var userAnswerNumber = 0
    
    var isThreeKind = false
    var isStraight = false
    var isFlush = false
    var isFullHouse = false
    var isFourKind = false
    var isStraightFlush = false
    var isRoyal = false
    var result = ""
    var cardsUsed = [Card]()
    var pairCount = 0
    
    func createDeck() {
        deck = playingCard.createDeck()
    }
    
    func shuffleDeck() {
        deck = playingCard.shuffleDeck(deck: deck)
    }
    
    func getCurrentDeck() -> [Card] {
        return deck
    }
    
    func calculateAnswerCards(userHand: [Card]) -> (String, [Card]) {
        isThreeKind = false
        isStraight = false
        isFlush = false
        isFullHouse = false
        isFourKind = false
        isStraightFlush = false
        isRoyal = false
        result = ""
        cardsUsed = [Card]()
        pairCount = 0
        
        let card1 = userHand[0]
        let card2 = userHand[1]
        let card3 = userHand[2]
        let card4 = userHand[3]
        let card5 = userHand[4]
        
        // Create array of Values and Sort
        var values = [Int]()
        for idx in userHand {
            let val = idx.value
            values.append(val)
        }
        values.sort()
        
        // Check for royal flush
        if card1.suit == card2.suit && card2.suit == card3.suit && card3.suit == card4.suit && card4.suit == card5.suit && values[0] == 1 && values[1] == 10 && values[2] == 11 && values[3] == 12 && values[4] == 13 {
            cardsUsed = userHand
            isRoyal = true
        }
        if isRoyal {
            result = "Royal Flush"
            cardsUsed = userHand
            return (result, cardsUsed)
        }

        // Check for straight flush
        if card1.suit == card2.suit && card2.suit == card3.suit && card3.suit == card4.suit && card4.suit == card5.suit && values[1] == values[0] + 1 && values[2] == values[1] + 1 && values[3] == values[2] + 1 && values[4] == values[3] + 1 {
            cardsUsed = userHand
            isStraightFlush = true
        }
        if isStraightFlush {
            result = "Straight Flush"
            cardsUsed = userHand
            return (result, cardsUsed)
        }
        
        // Check for 4 of a kind
        // 1234 1235 1245 1345 2345
        if card1.value == card2.value && card2.value == card3.value && card3.value == card4.value {
            cardsUsed.append(card1)
            cardsUsed.append(card2)
            cardsUsed.append(card3)
            cardsUsed.append(card4)
            isFourKind = true
        }
        if card1.value == card2.value && card2.value == card3.value && card3.value == card5.value {
            cardsUsed.append(card1)
            cardsUsed.append(card2)
            cardsUsed.append(card3)
            cardsUsed.append(card5)
            isFourKind = true
        }
        if card1.value == card2.value && card2.value == card4.value && card4.value == card5.value {
            cardsUsed.append(card1)
            cardsUsed.append(card2)
            cardsUsed.append(card4)
            cardsUsed.append(card5)
            isFourKind = true
        }
        if card2.value == card3.value && card3.value == card4.value && card4.value == card5.value {
            cardsUsed.append(card2)
            cardsUsed.append(card3)
            cardsUsed.append(card4)
            cardsUsed.append(card5)
            isFourKind = true
        }
        if isFourKind {
            result = "Four of a Kind"
            return (result, cardsUsed)
        }

        // Check for Full House
        if card1.value == card2.value && card2.value == card3.value && card4.value == card5.value {
            cardsUsed = userHand
            isFullHouse = true
        }
        if card2.value == card3.value && card3.value == card4.value && card1.value == card5.value {
            cardsUsed = userHand
            isFullHouse = true
        }
        if card1.value == card3.value && card3.value == card4.value && card2.value == card5.value {
            cardsUsed = userHand
            isFullHouse = true
        }
        if card1.value == card2.value && card2.value == card4.value && card3.value == card5.value {
            cardsUsed = userHand
            isFullHouse = true
        }
        if card1.value == card2.value && card2.value == card5.value && card3.value == card4.value {
            cardsUsed = userHand
            isFullHouse = true
        }
        if card1.value == card3.value && card3.value == card5.value && card2.value == card4.value  {
            cardsUsed = userHand
            isFullHouse = true
        }
        if card1.value == card4.value && card4.value == card5.value && card2.value == card3.value {
            cardsUsed = userHand
            isFullHouse = true
        }
        if card2.value == card3.value && card3.value == card5.value && card1.value == card4.value {
            cardsUsed = userHand
            isFullHouse = true
        }
        if card3.value == card4.value && card4.value == card5.value && card1.value == card2.value {
            cardsUsed = userHand
            isFullHouse = true
        }
        if isFullHouse {
            result = "Full House"
            return (result, cardsUsed)
        }
        
        // Check for flush
        if card1.suit == card2.suit && card2.suit == card3.suit && card3.suit == card4.suit && card4.suit == card5.suit {
            isFlush = true
        }
        if isFlush {
            result = "Flush"
            cardsUsed = userHand
            return (result, cardsUsed)
        }
        
        // Check for Ace high straight
        if values[0] == 1 && values[1] == 10 && values[2] == 11 && values[3] == 12 && values[4] == 13 {
            
            isStraight = true
        }
        if isStraight {
            result = "Straight"
            cardsUsed = userHand
            return (result, cardsUsed)
        }
        
        // Check for straight
        if values[1] == values[0] + 1 && values[2] == values[1] + 1 && values[3] == values[2] + 1 && values[4] == values[3] + 1 {
            
            isStraight = true
        }
        if isStraight {
            result = "Straight"
            cardsUsed = userHand
            return (result, cardsUsed)
        }
        
        // 123 234 134 124 125 135 145 235 345
        // Check for 3 of a kind
        if card1.value == card2.value && card2.value == card3.value {
            cardsUsed.append(card1)
            cardsUsed.append(card2)
            cardsUsed.append(card3)
            isThreeKind = true
        }
        if card2.value == card3.value && card3.value == card4.value {
            cardsUsed.append(card2)
            cardsUsed.append(card3)
            cardsUsed.append(card4)
            isThreeKind = true
        }
        if card1.value == card3.value && card3.value == card4.value {
            cardsUsed.append(card1)
            cardsUsed.append(card3)
            cardsUsed.append(card4)
            isThreeKind = true
        }
        if card1.value == card2.value && card2.value == card4.value {
            cardsUsed.append(card1)
            cardsUsed.append(card2)
            cardsUsed.append(card4)
            isThreeKind = true
        }
        if card1.value == card2.value && card2.value == card5.value {
            cardsUsed.append(card1)
            cardsUsed.append(card2)
            cardsUsed.append(card5)
            isThreeKind = true
        }
        if card1.value == card3.value && card3.value == card5.value {
            cardsUsed.append(card1)
            cardsUsed.append(card3)
            cardsUsed.append(card5)
            isThreeKind = true
        }
        if card1.value == card4.value && card4.value == card5.value {
            cardsUsed.append(card1)
            cardsUsed.append(card4)
            cardsUsed.append(card5)
            isThreeKind = true
        }
        if card2.value == card3.value && card3.value == card5.value {
            cardsUsed.append(card2)
            cardsUsed.append(card3)
            cardsUsed.append(card5)
            isThreeKind = true
        }
        if card3.value == card4.value && card4.value == card5.value {
            cardsUsed.append(card3)
            cardsUsed.append(card4)
            cardsUsed.append(card5)
            isThreeKind = true
        }
        if isThreeKind {
            result = "Three of a Kind"
            return (result, cardsUsed)
        }
        
        // Check for pairs
        self.checkForPair(card1: card1, card2: card2, card3: card3, card4: card4, card5: card5)
        
        if pairCount == 2 {
            result = "Two Pair"
            return (result, cardsUsed)
        }
        if pairCount == 1 {
            result = "Pair"
            return (result, cardsUsed)
        }
        
       result = "You got nothing!"
       return (result, cardsUsed)
    }
    
    func checkForPair(card1: Card, card2: Card, card3: Card, card4: Card, card5: Card) {
        if card1.value == card2.value {
            cardsUsed.append(card1)
            cardsUsed.append(card2)
            pairCount += 1
        }
        if card1.value == card3.value {
            cardsUsed.append(card1)
            cardsUsed.append(card3)
            pairCount += 1
        }
        if card1.value == card4.value {
            cardsUsed.append(card1)
            cardsUsed.append(card4)
            pairCount += 1
        }
        if card1.value == card5.value {
            cardsUsed.append(card1)
            cardsUsed.append(card5)
            pairCount += 1
        }
        if card2.value == card3.value {
            cardsUsed.append(card2)
            cardsUsed.append(card3)
            pairCount += 1
        }
        if card2.value == card4.value {
            cardsUsed.append(card2)
            cardsUsed.append(card4)
            pairCount += 1
        }
        if card2.value == card5.value {
            cardsUsed.append(card2)
            cardsUsed.append(card5)
            pairCount += 1
        }
        if card3.value == card4.value {
            cardsUsed.append(card3)
            cardsUsed.append(card4)
            pairCount += 1
        }
        if card3.value == card5.value {
            cardsUsed.append(card3)
            cardsUsed.append(card5)
            pairCount += 1
        }
        if card4.value == card5.value {
            cardsUsed.append(card4)
            cardsUsed.append(card5)
            pairCount += 1
        }
    }
    
    func checkBonusPoints(userHand: [Card], bonusHand: String, generalHandUserHas: String) -> Int {
        
        var handKeys = [String]()
        var handValues = [Int]()
        var dict = [String:Any]()
        
        if let url = Bundle.main.url(forResource:"GameHands", withExtension: "plist"),
            let myDict = NSDictionary(contentsOf: url) as? [String:Any] {
            dict = myDict
            for (key, value) in myDict {
                handKeys.append(key)
                handValues.append(value as! Int)
            }
        }
        print("Dict +++ \(dict)")
        let card1: Card?
        let card2: Card?
        let card3: Card?
        let card4: Card?
        let card5: Card?
        
        if userHand.count == 5 {
            card1 = userHand[0]
            card2 = userHand[1]
            card3 = userHand[2]
            card4 = userHand[3]
            card5 = userHand[4]
        }
        
        // Create array of Values and Sort
        var values = [Int]()
        for idx in userHand {
            let val = idx.value
            values.append(val)
        }
        values.sort()
        
        print("Bonus Hand \(bonusHand)")
        print("Bonus Hand \(generalHandUserHas)")
        
        // Get any Pair
        if bonusHand == "Get any Pair" {
            if generalHandUserHas == "Pair" {
                return dict["Get any Pair"] as! Int
            } 
        }
        // Get any Two Pair
        if bonusHand == "Get any Two Pair" {
            if generalHandUserHas == "Two Pair" {
                return dict["Get any Two Pair"] as! Int
            }
        }
        // Get any Three of a Kind
        if bonusHand == "Get any Three of a Kind" {
            if generalHandUserHas == "Three of a Kind" {
                return dict["Get any Three of a Kind"] as! Int
            }
        }
        // Get any Straight
        if bonusHand == "Get any Straight" {
            if generalHandUserHas == "Straight" {
                return dict["Get any Straight"] as! Int
            }
        }
        // Get any Flush
        if bonusHand == "Get any Flush" {
            if generalHandUserHas == "Flush" {
                return dict["Get any Flush"] as! Int
            }
        }
        // Get any Full House
        if bonusHand == "Get any Full House" {
            if generalHandUserHas == "Full House" {
                return dict["Get any Full House"] as! Int
            }
        }
        // Get any Four of a Kind
        if bonusHand == "Get any Four of a Kind" {
            if generalHandUserHas == "Four of a Kind" {
                return dict["Get any Four of a Kind"] as! Int
            }
        }
        // Get any Straight Flush
        if bonusHand == "Get any Straight Flush" {
            if generalHandUserHas == "Straight Flush" {
                return dict["Get any Straight Flush"] as! Int
            }
        }
        // Get any Royal Flush
        if bonusHand == "Get any Royal Flush" {
            if generalHandUserHas == "Royal Flush" {
                return dict["Get any Royal Flush"] as! Int
            }
        }
        // Get a Pair of 2's
        if bonusHand == "Get a Pair of 2's" {
            print("In Get Pair Of 2's")
            if generalHandUserHas == "Pair" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 2 {
                    return dict["Get a Pair of 2's"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get a Pair of 3's
        if bonusHand == "Get a Pair of 3's" {
            print("In Get Pair Of 3's")
            if generalHandUserHas == "Pair" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 3 {
                    return dict["Get a Pair of 3's"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get a Pair of 4's
        if bonusHand == "Get a Pair of 4's" {
            print("In Get Pair Of 4's")
            if generalHandUserHas == "Pair" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 4 {
                    return dict["Get a Pair of 4's"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get a Pair of 5's
        if bonusHand == "Get a Pair of 5's" {
            print("In Get Pair Of 5's")
            if generalHandUserHas == "Pair" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 5 {
                    return dict["Get a Pair of 5's"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get a Pair of 6's
        if bonusHand == "Get a Pair of 6's" {
            print("In Get Pair Of 6's")
            if generalHandUserHas == "Pair" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 6 {
                    return dict["Get a Pair of 6's"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get a Pair of 7's
        if bonusHand == "Get a Pair of 7's" {
            print("In Get Pair Of 7's")
            if generalHandUserHas == "Pair" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 7 {
                    return dict["Get a Pair of 7's"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get a Pair of 8's
        if bonusHand == "Get a Pair of 8's" {
            print("In Get Pair Of 8's")
            if generalHandUserHas == "Pair" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 8 {
                    return dict["Get a Pair of 8's"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get a Pair of 9's
        if bonusHand == "Get a Pair of 9's" {
            print("In Get Pair Of 9's")
            if generalHandUserHas == "Pair" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 9 {
                    return dict["Get a Pair of 9's"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get a Pair of 10's
        if bonusHand == "Get a Pair of 10's" {
            print("In Get Pair Of 10's")
            if generalHandUserHas == "Pair" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 10 {
                    return dict["Get a Pair of 10's"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get a Pair of Jacks
        if bonusHand == "Get a Pair of Jacks" {
            print("In Get Pair Of Jacks")
            if generalHandUserHas == "Pair" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 11 {
                    return dict["Get a Pair of Jacks"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get a Pair of Queens
        if bonusHand == "Get a Pair of Queens" {
            print("In Get Pair Of Queens")
            if generalHandUserHas == "Pair" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 12 {
                    return dict["Get a Pair of Queens"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get a Pair of Kings
        if bonusHand == "Get a Pair of Kings" {
            print("In Get Pair Of Kings")
            if generalHandUserHas == "Pair" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 13 {
                    return dict["Get a Pair of Kings"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get a Pair of Aces
        if bonusHand == "Get a Pair of Ace's" {
            print("Get a Pair of Ace's")
            if generalHandUserHas == "Pair" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 1 {
                    return dict["Get a Pair of Ace's"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get Three 2's
        if bonusHand == "Get Three 2's" {
            print("Get Three 2's")
            if generalHandUserHas == "Three of a Kind" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 2 {
                    return dict["Get Three 2's"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get Three 3's
        if bonusHand == "Get Three 3's" {
            print("Get Three 3's")
            if generalHandUserHas == "Three of a Kind" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 3 {
                    return dict["Get Three 3's"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get Three 4's
        if bonusHand == "Get Three 4's" {
            print("Get Three 4's")
            if generalHandUserHas == "Three of a Kind" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 4 {
                    return dict["Get Three 4's"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get Three 5's
        if bonusHand == "Get Three 5's" {
            print("Get Three 5's")
            if generalHandUserHas == "Three of a Kind" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 5 {
                    return dict["Get Three 5's"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get Three 6's
        if bonusHand == "Get Three 6's" {
            print("Get Three 6's")
            if generalHandUserHas == "Three of a Kind" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 6 {
                    return dict["Get Three 6's"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get Three 7's
        if bonusHand == "Get Three 7's" {
            print("Get Three 7's")
            if generalHandUserHas == "Three of a Kind" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 7 {
                    return dict["Get Three 7's"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get Three 8's
        if bonusHand == "Get Three 8's" {
            print("Get Three 8's")
            if generalHandUserHas == "Three of a Kind" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 8 {
                    return dict["Get Three 8's"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get Three 9's
        if bonusHand == "Get Three 9's" {
            print("Get Three 9's")
            if generalHandUserHas == "Three of a Kind" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 9 {
                    return dict["Get Three 9's"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get Three 10's
        if bonusHand == "Get Three 10's" {
            print("Get Three 10's")
            if generalHandUserHas == "Three of a Kind" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 10 {
                    return dict["Get Three 10's"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get Three Jacks
        if bonusHand == "Get Three Jacks" {
            print("Get Three Jacks")
            if generalHandUserHas == "Three of a Kind" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 11 {
                    return dict["Get Three Jacks"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get Three Queens
        if bonusHand == "Get Three Queens" {
            print("Get Three Queens")
            if generalHandUserHas == "Three of a Kind" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 12 {
                    return dict["Get Three Queens"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get Three Kings
        if bonusHand == "Get Three Kings" {
            print("Get Three Kings")
            if generalHandUserHas == "Three of a Kind" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 13 {
                    return dict["Get Three Kings"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get Three Aces
        if bonusHand == "Get Three Aces" {
            print("Get Three Aces")
            if generalHandUserHas == "Three of a Kind" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 1 {
                    return dict["Get Three Aces"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get Four 2's
        if bonusHand == "Get Four 2's" {
            print("Get Four 2's")
            if generalHandUserHas == "Four of a Kind" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 2 {
                    return dict["Get Four 2's"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get Four 3's
        if bonusHand == "Get Four 3's" {
            print("Get Four 3's")
            if generalHandUserHas == "Four of a Kind" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 3 {
                    return dict["Get Four 3's"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get Four 4's
        if bonusHand == "Get Four 4's" {
            print("Get Four 4's")
            if generalHandUserHas == "Four of a Kind" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 4 {
                    return dict["Get Four 4's"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get Three 5's
        if bonusHand == "Get Four 5's" {
            print("Get Four 5's")
            if generalHandUserHas == "Four of a Kind" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 5 {
                    return dict["Get Four 5's"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get Four 6's
        if bonusHand == "Get Four 6's" {
            print("Get Four 6's")
            if generalHandUserHas == "Four of a Kind" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 6 {
                    return dict["Get Four 6's"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get Four 7's
        if bonusHand == "Get Four 7's" {
            print("Get Four 7's")
            if generalHandUserHas == "Four of a Kind" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 7 {
                    return dict["Get Four 7's"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get Four 8's
        if bonusHand == "Get Four 8's" {
            print("Get Four 8's")
            if generalHandUserHas == "Four of a Kind" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 8 {
                    return dict["Get Four 8's"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get Four 9's
        if bonusHand == "Get Four 9's" {
            print("Get Four 9's")
            if generalHandUserHas == "Four of a Kind" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 9 {
                    return dict["Get Four 9's"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get Four 10's
        if bonusHand == "Get Four 10's" {
            print("Get Four 10's")
            if generalHandUserHas == "Four of a Kind" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 10 {
                    return dict["Get Four 10's"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get Four Jacks
        if bonusHand == "Get Four Jacks" {
            print("Get Four Jacks")
            if generalHandUserHas == "Four of a Kind" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 11 {
                    return dict["Get Four Jacks"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get Four Queens
        if bonusHand == "Get Four Queens" {
            print("Get Four Queens")
            if generalHandUserHas == "Four of a Kind" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 12 {
                    return dict["Get Four Queens"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get Four Kings
        if bonusHand == "Get Four Kings" {
            print("Get Four Kings")
            if generalHandUserHas == "Four of a Kind" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 13 {
                    return dict["Get Four Kings"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get Four Aces
        if bonusHand == "Get Four Aces" {
            print("Get Four Aces")
            if generalHandUserHas == "Four of a Kind" {
                print("Userhand ++ \(userHand[0].value)")
                if userHand[0].value == 1 {
                    return dict["Get Four Aces"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get 5 high Straight
        if bonusHand == "Get 5 high Straight" {
            print("Get 5 high Straight")
            if generalHandUserHas == "Straight" {
                print("UseraValues ++ \(values)")
                if values[4] == 5 {
                    return dict["Get 5 high Straight"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get 6 high Straight
        if bonusHand == "Get 6 high Straight" {
            print("Get 6 high Straight")
            if generalHandUserHas == "Straight" {
                print("UseraValues ++ \(values)")
                if values[4] == 6 {
                    return dict["Get 6 high Straight"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get 7 high Straight
        if bonusHand == "Get 7 high Straight" {
            print("Get 7 high Straight")
            if generalHandUserHas == "Straight" {
                print("UseraValues ++ \(values)")
                if values[4] == 7 {
                    return dict["Get 7 high Straight"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get 8 high Straight
        if bonusHand == "Get 8 high Straight" {
            print("Get 8 high Straight")
            if generalHandUserHas == "Straight" {
                print("UseraValues ++ \(values)")
                if values[4] == 8 {
                    return dict["Get 8 high Straight"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get 9 high Straight
        if bonusHand == "Get 9 high Straight" {
            print("Get 9 high Straight")
            if generalHandUserHas == "Straight" {
                print("UseraValues ++ \(values)")
                if values[4] == 9 {
                    return dict["Get 9 high Straight"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get 10 high Straight
        if bonusHand == "Get 10 high Straight" {
            print("Get 10 high Straight")
            if generalHandUserHas == "Straight" {
                print("UseraValues ++ \(values)")
                if values[4] == 10 {
                    return dict["Get 10 high Straight"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get Jack high Straight
        if bonusHand == "Get Jack high Straight" {
            print("Get Jack high Straight")
            if generalHandUserHas == "Straight" {
                print("UseraValues ++ \(values)")
                if values[4] == 11 {
                    return dict["Get Jack high Straight"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get Queen high Straight
        if bonusHand == "Get Queen high Straight" {
            print("Get Queen high Straight")
            if generalHandUserHas == "Straight" {
                print("UseraValues ++ \(values)")
                if values[4] == 12 {
                    return dict["Get Queen high Straight"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get King high Straight
        if bonusHand == "Get King high Straight" {
            print("Get King high Straight")
            if generalHandUserHas == "Straight" {
                print("UseraValues ++ \(values)")
                if values[4] == 13 {
                    return dict["Get King high Straight"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        // Get Ace high Straight
        if bonusHand == "Get Ace high Straight" {
            print("Get Ace high Straight")
            if generalHandUserHas == "Straight" {
                print("UseraValues ++ \(values)")
                if values[0] == 1 {
                    return dict["Get Ace high Straight"] as! Int
                }
                return 0
            } else {
                return 0
            }
        }
        
        return 0
    }
    
    
    
    
}
