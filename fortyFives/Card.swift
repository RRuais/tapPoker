//
//  Card.swift
//  fortyFives
//
//  Created by Rich Ruais on 9/29/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.
//

import UIKit
import SpriteKit

class CardNode: SKSpriteNode {
    
    var cardTexture: SKTexture?
    var playingCard: Card?
    var parentView: SKScene?
    
    init(imageName: String, playingCard: Card) {
        cardTexture = SKTexture(imageNamed: imageName)
        let size = CGSize(width: (cardTexture?.size().width)! / 6, height: (cardTexture?.size().height)! / 6)
        self.playingCard = playingCard
        super.init(texture: cardTexture, color: UIColor.clear, size: size)
        setup()
    }
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity = true
        physicsBody?.categoryBitMask = BodyType.card
        physicsBody?.contactTestBitMask = BodyType.bottomScreen
        physicsBody?.collisionBitMask = 0
        self.zPosition = 0
    }
    
    
}

