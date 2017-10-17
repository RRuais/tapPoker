//
//  AddTimeBall.swift
//  fortyFives
//
//  Created by Rich Ruais on 10/5/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.
//

import UIKit
import SpriteKit

class AddTimeBall: SKShapeNode {
    
    override init() {
        super.init()
    }
    
    convenience init(circleOfRadius: CGFloat) {
        self.init()
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        let path1 = CGMutablePath()
        path1.addArc(center: CGPoint.zero,
                     radius: 15,
                     startAngle: 0,
                     endAngle: CGFloat.pi * 2,
                     clockwise: true)
        path = path1
        lineWidth = 1
        fillColor = .yellow
        glowWidth = 0.5
        physicsBody = SKPhysicsBody(circleOfRadius: 15)
        physicsBody?.affectedByGravity = true
        physicsBody?.categoryBitMask = BodyType.addTimeBall
        physicsBody?.contactTestBitMask = BodyType.bottomScreen
        physicsBody?.collisionBitMask = 0
    }
    
    
}
