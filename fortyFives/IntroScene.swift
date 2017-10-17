//
//  IntroScene.swift
//  fortyFives
//
//  Created by Rich Ruais on 10/11/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.
//

import Foundation
import SpriteKit

class IntroScene: SKScene, SKPhysicsContactDelegate {
    
    var gameLogic = GameLogic()
    var deck = [Card]()
    var hand = [Card]()
    var cardCounter = 0
    var scoreCounter = 0
    var gameTimeCounter = 0
    var cardDropRate = 1.2
    var freeChipFallRate = [5, 20, 30, 50]
    var addChipFallRate = [10, 25, 40]
    var pointsChipFallRate = [7, 22, 32, 51]

    override func didMove(to view: SKView) {
        setupDeck()
        let background = SKSpriteNode(color: UIColor.clear, size: (self.view?.frame.size)!)
        background.zPosition = -1
        background.position = CGPoint(x: 0, y: 0)
        background.size = frame.size
        self.addChild(background)
    }
    
    func setupDeck() {
        deck.removeAll()
        gameLogic.createDeck()
        gameLogic.shuffleDeck()
        deck = gameLogic.getCurrentDeck()
        for card in hand {
            if deck.contains(card) {
                let index = deck.index(of: card)
                deck.remove(at: index!)
            }
        }
        cardCounter = 0
        fallingCards()
    }
    
    func fallingCards() {
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(spawnCard),
                SKAction.wait(forDuration: cardDropRate)])), withKey: "fallingCards")
    }
    
    func stopFallingCards() {
        removeAction(forKey: "fallingCards")
    }
    
    func spawnCard() {
        if deck.count == 0 {
            self.setupDeck()
        } else {
            let playingCard = deck[0]
            let cardNode: CardNode = CardNode(imageName: deck[0].imageName, playingCard: playingCard)
            cardNode.physicsBody?.allowsRotation = true
            // All odd numbers
            if cardCounter % 2 == 1 {
                let rotateAction = SKAction.rotate(byAngle: CGFloat(Double.pi), duration:0.7)
                cardNode.run(SKAction.repeatForever(rotateAction))
            }
            // Fast Spin
            if cardCounter == 10 || cardCounter == 20 || cardCounter == 40 {
                let rotateAction = SKAction.rotate(byAngle: CGFloat(Double.pi), duration:0.5)
                cardNode.run(SKAction.repeatForever(rotateAction))
            }
            // Slow spin
            if cardCounter == 6 || cardCounter == 8 || cardCounter == 16 || cardCounter == 26 || cardCounter == 28 || cardCounter == 36 || cardCounter == 38 {
                let rotateAction = SKAction.rotate(byAngle: CGFloat(Double.pi), duration:2.0)
                cardNode.run(SKAction.repeatForever(rotateAction))
            }
            let width = UIScreen.main.bounds.width / 2
            let randX = randomIntFrom(start: -(Int)(width), to: Int(width))
            cardNode.position = CGPoint(x: randX, y: 300)
            self.addChild(cardNode)
            deck.remove(at: 0)
            cardCounter += 1
        }
        for i in freeChipFallRate {
            if cardCounter == i {
                spawnFreeCardBall()
            }
        }
        for i in addChipFallRate {
            if cardCounter == i {
                spawnAddTimeBall()
            }
        }
        for i in pointsChipFallRate {
            if cardCounter == i {
                spawnAddPointsBall()
            }
        }
    }
    
    func spawnFreeCardBall() {
        let chip = freeCardChip(imageName: "chip1")
        let width = UIScreen.main.bounds.width / 2
        let randX = randomIntFrom(start: -(Int)(width), to: Int(width))
        chip.position = CGPoint(x: randX, y: 300)
        self.addChild(chip)
    }
    
    func spawnAddTimeBall() {
        let chip = AddTimeChip(imageName: "chip2")
        let width = UIScreen.main.bounds.width / 2
        let randX = randomIntFrom(start: -(Int)(width), to: Int(width))
        chip.position = CGPoint(x: randX, y: 300)
        self.addChild(chip)
    }
    
    func spawnAddPointsBall() {
        let chip = AddPointsChip(imageName: "chip3")
        let width = UIScreen.main.bounds.width / 2
        let randX = randomIntFrom(start: -(Int)(width), to: Int(width))
        chip.position = CGPoint(x: randX, y: 300)
        self.addChild(chip)
    }

    
    
}
