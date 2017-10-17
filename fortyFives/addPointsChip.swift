//
//  addPointsChip.swift
//  fortyFives
//
//  Created by Rich Ruais on 10/11/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.
//


import Foundation
import SpriteKit

class AddPointsChip: SKSpriteNode {
    
    var chipTexture: SKTexture?
    var parentView: SKScene?
    
    init(imageName: String) {
        chipTexture = SKTexture(imageNamed: imageName)
        let size = CGSize(width: (chipTexture?.size().width)! / 4, height: (chipTexture?.size().height)! / 4)
        super.init(texture: chipTexture, color: UIColor.clear, size: size)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        physicsBody = SKPhysicsBody(circleOfRadius: 100)
        physicsBody?.affectedByGravity = true
        physicsBody?.categoryBitMask = BodyType.card
        physicsBody?.contactTestBitMask = BodyType.bottomScreen
        physicsBody?.collisionBitMask = 0
        self.zPosition = 0
    }
    
    
}

