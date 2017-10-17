//
//  GameScene.swift
//  fortyFives
//
//  Created by Rich Ruais on 9/29/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Game Variables
    var parentVC: UIViewController? = nil
    var gameLogic = GameLogic()
    var deck = [Card]()
    var hand = [Card]() {
        didSet {
            if hand.count == 5 {
                checkAnswerCards()
            }
        }
    }
    var masterGameTime = 60
    var cardCounter = 0
    var scoreCounter = 0
    var gameTimeCounter = 0
    var userScore = FinalScore()
    var gameDifficulty = String()
    var cardDropRate = 1.2
    var gameIsStarted = false
    var gameIsPaused = false
    var freeChipFallRate = [Int]()
    var addChipFallRate = [Int]()
    var pointsChipFallRate = [Int]()
    var bonusHand = ""
    var bonusHandValue = Int()
    // Game Views
    var bottomScreen: SKSpriteNode?
    var topScreen: SKSpriteNode?
    var answerCard1: SKSpriteNode?
    var answerCard2: SKSpriteNode?
    var answerCard3: SKSpriteNode?
    var answerCard4: SKSpriteNode?
    var answerCard5: SKSpriteNode?
    var answerCards = [SKSpriteNode]()
    var explosionParticle = SKEmitterNode(fileNamed: "Explode")
    var chipExplode = SKEmitterNode(fileNamed: "ChipExplode")
    var handLabel: SKLabelNode?
    var scoreLabel: SKLabelNode?
    var startGameLabel: SKLabelNode?
    var timerLabel: SKLabelNode?
    var bonusLabel: SKLabelNode?
    var optionsButton: SKSpriteNode?
    var currenthandLabel: SKLabelNode?
    var currentBonusLabel: SKLabelNode?
    var goDelegate: GameOverDelegate?
    var fcDelegate: FreeCardPopupDelegate?
    var omDelegate: optionsMenuPopupDelegate?
    
    
    override func didMove(to view: SKView) {
        setupDifficulty()
        setupInitialView()
    }
    
    func setupDifficulty() {
        if gameDifficulty == "easy" {
            masterGameTime = 90
            gameTimeCounter = masterGameTime
            cardDropRate = 1.2
            freeChipFallRate = [4, 20, 30, 50]
            addChipFallRate = [10, 25, 35, 40]
            pointsChipFallRate = [7, 22, 32, 51]
        }
        if gameDifficulty == "medium" {
            masterGameTime = 70
            gameTimeCounter = masterGameTime
            cardDropRate = 0.9
            freeChipFallRate = [5, 20, 50]
            addChipFallRate = [10, 25, 35]
            pointsChipFallRate = [7, 22, 32]
        }
        if gameDifficulty == "hard" {
            masterGameTime = 70
            gameTimeCounter = masterGameTime
            cardDropRate = 0.6
            freeChipFallRate = [5, 20, 50]
            addChipFallRate = [10, 40]
            pointsChipFallRate = [7, 22, 32]
        }
        if gameDifficulty == "practice" {
            masterGameTime = 40
            gameTimeCounter = masterGameTime
            cardDropRate = 1.2
            freeChipFallRate = [5, 20, 50]
            addChipFallRate = [10, 40]
            pointsChipFallRate = [7, 22, 32, 51]
        }
    }
    
    func setupInitialView() {
        
        let background = SKSpriteNode(color: UIColor.black, size: (self.view?.frame.size)!)
        let background2 = SKSpriteNode(imageNamed: "felt")
        
        background2.zPosition = -1
        background2.position = CGPoint(x: 0, y: 0)
        background2.size = frame.size
        self.addChild(background2)
        
        // Setup physics world
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        let sceneBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = sceneBody
        self.physicsBody?.contactTestBitMask = BodyType.none
        
        // Setup bottom and top screen
        bottomScreen = self.childNode(withName: "bottomScreen") as? SKSpriteNode
        bottomScreen?.physicsBody = SKPhysicsBody(rectangleOf: (bottomScreen?.size)!)
        bottomScreen?.physicsBody?.affectedByGravity = false
        bottomScreen?.physicsBody?.isDynamic = false
        bottomScreen?.physicsBody?.categoryBitMask = BodyType.bottomScreen
        bottomScreen?.physicsBody?.contactTestBitMask = BodyType.card
        bottomScreen?.physicsBody?.collisionBitMask = 0
        bottomScreen?.zPosition = 1
        topScreen = self.childNode(withName: "topScreen") as? SKSpriteNode
        topScreen?.texture = SKTexture(imageNamed: "wood")
        topScreen?.physicsBody = SKPhysicsBody(rectangleOf: (bottomScreen?.size)!)
        topScreen?.physicsBody?.affectedByGravity = false
        topScreen?.physicsBody?.isDynamic = false
        topScreen?.physicsBody?.categoryBitMask = BodyType.bottomScreen
        topScreen?.physicsBody?.contactTestBitMask = BodyType.card
        topScreen?.physicsBody?.collisionBitMask = 0
        topScreen?.zPosition = 1
        
        optionsButton = self.childNode(withName: "options") as? SKSpriteNode
        optionsButton?.physicsBody = SKPhysicsBody(rectangleOf: (optionsButton?.size)!)
        optionsButton?.physicsBody?.affectedByGravity = false
        optionsButton?.physicsBody?.isDynamic = false
        optionsButton?.physicsBody?.categoryBitMask = BodyType.bottomScreen
        optionsButton?.physicsBody?.contactTestBitMask = BodyType.card
        optionsButton?.physicsBody?.collisionBitMask = 0
        optionsButton?.zPosition = 2
        
        // Setup Labels
        handLabel = self.childNode(withName: "handLabel") as? SKLabelNode
        handLabel?.zPosition = 3
        handLabel?.text = "Prev Hand"
        scoreLabel = self.childNode(withName: "scoreLabel") as? SKLabelNode
        scoreLabel?.zPosition = 3
        scoreLabel?.text = "\(scoreCounter)"
        startGameLabel = self.childNode(withName: "startGameLabel") as? SKLabelNode
        startGameLabel?.zPosition = 3
        startGameLabel?.text = "Start Game"
        startGameLabel?.fontColor = UIColor.white
        timerLabel = self.childNode(withName: "timerLabel") as? SKLabelNode
        timerLabel?.text = "\(gameTimeCounter)"
        timerLabel?.zPosition = 3
        currenthandLabel = self.childNode(withName: "currenthandLabel") as? SKLabelNode
        currenthandLabel?.text = ""
        currenthandLabel?.zPosition = 3
        currenthandLabel?.isHidden = true
        bonusLabel = self.childNode(withName: "bonusPoints") as? SKLabelNode
        bonusLabel?.text = "Bonus Hand"
        bonusLabel?.zPosition = 3
        currentBonusLabel = self.childNode(withName: "currentBonusLabel") as? SKLabelNode
        currentBonusLabel?.text = ""
        currentBonusLabel?.zPosition = 3
        currentBonusLabel?.isHidden = true
        let pointsTitleLabel = self.childNode(withName: "pointsTitleLabel") as? SKLabelNode
        pointsTitleLabel?.zPosition = 3
        let pointsTimerLabel = self.childNode(withName: "pointsTimerLabel") as? SKLabelNode
        pointsTimerLabel?.zPosition = 3
        let pokerTable = self.childNode(withName: "pokerTable")
        pokerTable?.zPosition = 2
        // Setup answer cards
        answerCard1 = (self.childNode(withName: "answerCard1") as? SKSpriteNode)!
        answerCard2 = (self.childNode(withName: "answerCard2") as? SKSpriteNode)!
        answerCard3 = (self.childNode(withName: "answerCard3") as? SKSpriteNode)!
        answerCard4 = (self.childNode(withName: "answerCard4") as? SKSpriteNode)!
        answerCard5 = (self.childNode(withName: "answerCard5") as? SKSpriteNode)!
        answerCards = [answerCard1!, answerCard2!, answerCard3!, answerCard4!, answerCard5!]
        for card in answerCards {
            card.texture = SKTexture(imageNamed: "back")
            card.physicsBody = SKPhysicsBody(rectangleOf: (bottomScreen?.size)!)
            card.physicsBody?.affectedByGravity = false
            card.physicsBody?.isDynamic = false
            card.physicsBody?.categoryBitMask = BodyType.bottomScreen
            card.physicsBody?.collisionBitMask = 0
            card.zPosition = 1
        }
    }
    
    func startGame() {
        gameIsStarted = true
        setupDeck()
        startGameLabel?.isHidden = true
        // Set bonus Hand
        readFromGameHandsPlist()
        let counterDecrement = SKAction.sequence([SKAction.wait(forDuration: 1.0),SKAction.run(setGameTime)])
        run(SKAction.sequence([SKAction.repeat(counterDecrement, count: gameTimeCounter), SKAction.run(stopGame)]), withKey: "gameTime")
    }
    
    func pauseGame() {
        gameIsPaused = true
        removeAction(forKey: "gameTime")
        stopFallingCards()
    }
    
    func resumeGame() {
        gameIsPaused = false
        for card in hand {
            if deck.contains(card) {
                let index = deck.index(of: card)
                deck.remove(at: index!)
            }
        }
        fallingCards()
        let counterDecrement = SKAction.sequence([SKAction.wait(forDuration: 1.0),SKAction.run(setGameTime)])
        run(SKAction.sequence([SKAction.repeat(counterDecrement, count: gameTimeCounter), SKAction.run(stopGame)]), withKey: "gameTime")
    }
    
    func setGameTime() {
        gameTimeCounter -= 1
        timerLabel?.text = "\(gameTimeCounter)"
    }
    
    func stopGame() {
        gameIsStarted = false
        stopFallingCards()
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.explodCardsOnScreen()
        }
        explodCardsOnScreen()
        calculateFinalScore()
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


    func checkAnswerCards() {
        print("Check Answer Cards")
        self.stopFallingCards()
        self.calculateAnswerCards()
    }
    
    func calculateAnswerCards() {

        var points = Points()
        let result = gameLogic.calculateAnswerCards(userHand: hand)
        var generalHandUserHas = ""
        var didGetBonus = false
        var pointsAdded = 0
        handLabel?.text = result.0
        
        if gameDifficulty == "medium" {
            points.pair *= 2
            points.twoPair *= 2
            points.threeKind *= 2
            points.straight *= 2
            points.flush *= 2
            points.fullHouse *= 2
            points.fourKind *= 2
            points.straightFlush *= 2
            points.royalFlush *= 2
        }
        if gameDifficulty == "hard" {
            points.pair *= 3
            points.twoPair *= 3
            points.threeKind *= 3
            points.straight *= 3
            points.flush *= 3
            points.fullHouse *= 3
            points.fourKind *= 3
            points.straightFlush *= 3
            points.royalFlush *= 3
        }
        
        if result.0 == "Pair" {
            scoreCounter += points.pair
            pointsAdded = points.pair
            userScore.pair += 1
            generalHandUserHas = "Pair"
        } else if result.0 == "Two Pair" {
            scoreCounter += points.twoPair
            pointsAdded = points.twoPair
            userScore.twoPair += 1
            generalHandUserHas = "Two Pair"
        } else if result.0 == "Three of a Kind" {
            scoreCounter += points.threeKind
            pointsAdded = points.threeKind
            userScore.threeKind += 1
            generalHandUserHas = "Three of a Kind"
        } else if result.0 == "Straight" {
            scoreCounter += points.straight
            pointsAdded = points.straight
            userScore.straight += 1
            generalHandUserHas = "Straight"
        } else if result.0 == "Flush" {
            scoreCounter += points.flush
            pointsAdded = points.flush
            userScore.flush += 1
            generalHandUserHas = "Flush"
        } else if result.0 == "Full House" {
            scoreCounter += points.fullHouse
            pointsAdded = points.fullHouse
            userScore.fullHouse += 1
            generalHandUserHas = "Full House"
        } else if result.0 == "Four of a Kind" {
            scoreCounter += points.fourKind
            pointsAdded = points.fourKind
            userScore.fourKind += 1
            generalHandUserHas = "Four of a Kind"
        } else if result.0 == "Straight Flush" {
            scoreCounter += points.straightFlush
            pointsAdded = points.straightFlush
            userScore.straightFlush += 1
            generalHandUserHas = "Straight Flush"
        } else if result.0 == "Royal Flush" {
            scoreCounter += points.royalFlush
            pointsAdded = points.royalFlush
            userScore.royalFlush += 1
            generalHandUserHas = "Royal Flush"
        } else if result.0 == "You got nothing!" {
            scoreCounter -= 20
            if scoreCounter < 0 {
                scoreCounter = 0
            }
            generalHandUserHas = "Nothing"
        }
    
        // Check for bonus points
        var bp = gameLogic.checkBonusPoints(userHand: result.1, bonusHand: bonusHand, generalHandUserHas: generalHandUserHas)
        print("Bonus +++ \(bp)")
        scoreCounter += bp
        
        if bp > 0 {
            didGetBonus = true
        }
        // Get next bonus hand
        readFromGameHandsPlist()
        scoreLabel?.text = "\(scoreCounter)"
        hand.removeAll()
        deck.removeAll()
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.pauseGame()
            self.resetAnswerCards()
            self.setupDeck()
            self.flashCurrentHand(result: result.0, didGetBonus: didGetBonus, bonusPoints: bp)
        }
    }
    
    func readFromGameHandsPlist() {
        if let url = Bundle.main.url(forResource:"GameHands", withExtension: "plist"),
            let myDict = NSDictionary(contentsOf: url) as? [String:Any] {
            var handKeys = [String]()
            var handValues = [Int]()
            for (key, value) in myDict {
                handKeys.append(key)
                handValues.append(value as! Int)
            }
            let randNumForHand = randomIndexForArray(array: handKeys)
            let nextHand = handKeys[randNumForHand]
            bonusLabel?.text = nextHand
            bonusHand = nextHand
            bonusHandValue = handValues[randNumForHand]
        }
    }
    
    func flashCurrentHand(result: String, didGetBonus: Bool, bonusPoints: Int) {
        currenthandLabel?.alpha = 0.0
        currenthandLabel?.isHidden = false
        currenthandLabel?.text = result
        currenthandLabel?.zPosition = 1
        currenthandLabel?.run(SKAction.fadeIn(withDuration: 1.0))
        
        if result == "You got nothing!" {
            currentBonusLabel?.alpha = 0.0
            currentBonusLabel?.isHidden = false
            currentBonusLabel?.text = "-20 Points"
            currentBonusLabel?.zPosition = 1
            currentBonusLabel?.run(SKAction.fadeIn(withDuration: 1.0))
        }
        
        if didGetBonus {
            currentBonusLabel?.alpha = 0.0
            currentBonusLabel?.isHidden = false
            currentBonusLabel?.text = "\(bonusPoints) Bonus Points!"
            currentBonusLabel?.zPosition = 1
            currentBonusLabel?.run(SKAction.fadeIn(withDuration: 1.0))
        }
        
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.currenthandLabel?.run(SKAction.fadeOut(withDuration: 1.0))
            self.currenthandLabel?.isHidden = true
            if didGetBonus || result == "You got nothing!" {
                self.currentBonusLabel?.run(SKAction.fadeOut(withDuration: 1.0))
                self.currentBonusLabel?.isHidden = true
            }
            self.resumeGame()
        }
    }
    
    func calculateFinalScore() {
        self.explodCardsOnScreen()
        print("Calculate Final Score")
        userScore.totalPoints = scoreCounter
        // Reset Variables
        cardCounter = 0
        scoreCounter = 0
        gameTimeCounter = masterGameTime
        scoreLabel?.text = "\(scoreCounter)"
        timerLabel?.text = "\(gameTimeCounter)"
        handLabel?.text = "Prev Hand"
        bonusLabel?.text = "Bonus Points Hand"
        let scoreToSave = userScore
        userScore = FinalScore()
        resetAnswerCards()
        print("FINAL SCORE +++ \(userScore)")
        let when = DispatchTime.now() + 0.3
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.startGameLabel?.isHidden = false
            self.goDelegate?.gameOver(result: scoreToSave)
        }
    }
    
    func resetAnswerCards() {
        self.answerCard1!.texture = SKTexture(imageNamed: "back")
        self.answerCard2!.texture = SKTexture(imageNamed: "back")
        self.answerCard3!.texture = SKTexture(imageNamed: "back")
        self.answerCard4!.texture = SKTexture(imageNamed: "back")
        self.answerCard5!.texture = SKTexture(imageNamed: "back")
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
    
    func assignAnswer(cardTouched: CardNode) {
        let a: SKTexture = (answerCard1?.texture)!
        let b: SKTexture = (answerCard2?.texture)!
        let c: SKTexture = (answerCard3?.texture)!
        let d: SKTexture = (answerCard4?.texture)!
        let e: SKTexture = (answerCard5?.texture)!
        
        if a.description.contains("back") {
            let tempCard = cardTouched.playingCard
            if hand.contains(tempCard!) {
                // Dont Add
            } else {
                hand.append(tempCard!)
                let image = cardTouched.playingCard?.imageName
                answerCard1?.texture = SKTexture(imageNamed: image!)

            }
        } else {
            if b.description.contains("back") {
                let tempCard = cardTouched.playingCard
                if hand.contains(tempCard!) {
                    
                } else {
                hand.append(tempCard!)
                let image = cardTouched.playingCard?.imageName
                answerCard2?.texture = SKTexture(imageNamed: image!)
                }
            } else {
                if c.description.contains("back") {
                    let tempCard = cardTouched.playingCard
                    if hand.contains(tempCard!) {
                        
                    } else {
                    hand.append(tempCard!)
                    let image = cardTouched.playingCard?.imageName
                    answerCard3?.texture = SKTexture(imageNamed: image!)
                    }
                } else {
                    if d.description.contains("back") {
                        let tempCard = cardTouched.playingCard
                        if hand.contains(tempCard!) {
                            
                        } else {
                        hand.append(tempCard!)
                        let image = cardTouched.playingCard?.imageName
                        answerCard4?.texture = SKTexture(imageNamed: image!)
                        }
                    } else {
                        if e.description.contains("back") {
                            let tempCard = cardTouched.playingCard
                            if hand.contains(tempCard!) {
                                
                            } else {
                            hand.append(tempCard!)
                            let image = cardTouched.playingCard?.imageName
                            answerCard5?.texture = SKTexture(imageNamed: image!)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    // Mark: - Touches / Contact
    
    func didBegin(_ contact: SKPhysicsContact) {
    }
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let touchLocation = touch.location(in: self)
            // Touch Cards
            if let targetNode = atPoint(touchLocation) as? CardNode {
                // Check if explosion is already on screen
                if ((explosionParticle?.parent) != nil) {
                    print("Parent = true")
                    self.assignAnswer(cardTouched: targetNode)
                    targetNode.removeFromParent()
                } else {
                    print("Parent = false")
                    self.assignAnswer(cardTouched: targetNode)
                    explosionParticle?.position = CGPoint(x: touchLocation.x, y: touchLocation.y)
                    self.addChild(explosionParticle!)
                    targetNode.removeFromParent()
                    let when = DispatchTime.now() + 0.3
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        self.explosionParticle?.removeFromParent()
                    }
                }
            }
            // Touch Start Game Label
            if let labelNode = atPoint(touchLocation) as? SKLabelNode {
                if labelNode == self.childNode(withName: "startGameLabel") {
                    labelNode.run(SKAction.run(startGame))
                }
            }
            // Touch Options Button
            if let optionsButton = atPoint(touchLocation) as? SKSpriteNode {
                if optionsButton == self.childNode(withName: "options") {
                    self.pauseGame()
                    self.omDelegate?.showOptionsMenuPopup(scene: self)
                }
            }
            // Touch Answer Cards
            if let answerCardTouched = atPoint(touchLocation) as? SKSpriteNode {
                for i in 1...5 {
                    if answerCardTouched == self.childNode(withName: "answerCard\(i)") {
                        if answerCardTouched.texture?.name != "back" {
                            for card in hand {
                                if card.imageName == answerCardTouched.texture?.name {
                                    let index = hand.index(of: card)
                                    hand.remove(at: index!)
                                }
                            }
                            answerCardTouched.texture = SKTexture(imageNamed: "back")
                        }
                    }
                }
            }
            if let freeCardChip = atPoint(touchLocation) as? freeCardChip {
                // Check if chip explode is on screen
                if ((chipExplode?.parent) != nil) {
                    freeCardChip.removeFromParent()
                    self.pauseGame()
                    fcDelegate?.showFcPopup(hand: hand, scene: self)
                } else {
                    chipExplode?.position = CGPoint(x: touchLocation.x, y: touchLocation.y)
                    self.addChild(chipExplode!)
                    freeCardChip.removeFromParent()
                    let when = DispatchTime.now() + 0.3
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        self.chipExplode?.removeFromParent()
                    }
                    
                    if gameTimeCounter == 1 {
                       
                    } else {
                      self.pauseGame()
                      fcDelegate?.showFcPopup(hand: hand, scene: self)
                    }
                }
            }
            if let addTimeChip = atPoint(touchLocation) as? AddTimeChip {
                if ((chipExplode?.parent) != nil) {
                     addTimeChip.removeFromParent()
                     gameTimeCounter += 10
                } else {
                    chipExplode?.position = CGPoint(x: touchLocation.x, y: touchLocation.y)
                    self.addChild(chipExplode!)
                    addTimeChip.removeFromParent()
                    let when = DispatchTime.now() + 0.3
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        self.chipExplode?.removeFromParent()
                    }
                    gameTimeCounter += 10
                    self.pauseGame()
                    self.resumeGame()
                }
            }
            if let addPointsChip = atPoint(touchLocation) as? AddPointsChip {
                if ((chipExplode?.parent) != nil) {
                    addPointsChip.removeFromParent()
                    gameTimeCounter += 10
                } else {
                    chipExplode?.position = CGPoint(x: touchLocation.x, y: touchLocation.y)
                    self.addChild(chipExplode!)
                    addPointsChip.removeFromParent()
                    let when = DispatchTime.now() + 0.3
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        self.chipExplode?.removeFromParent()
                    }
                    scoreCounter += 20
                    scoreLabel?.text = "\(scoreCounter)"
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    // Helpers
    func explodCardsOnScreen() {
        print("Game Time  Explode")
        for node in self.children {
            if let targetNode = node as? CardNode {
                if ((explosionParticle?.parent) != nil) {
                    targetNode.removeFromParent()
                } else {
                    let explode = SKEmitterNode(fileNamed: "Explode")
                    print("In Target Node")
                    explode?.position = CGPoint(x: node.position.x, y: node.position.y)
                    self.addChild(explode!)
                    targetNode.removeFromParent()
                    let when = DispatchTime.now() + 0.3
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        explode?.removeFromParent()
                    }
                }
            }
        }
    }
// End Class
}

protocol GameOverDelegate {
    func gameOver(result: FinalScore)
}

protocol FreeCardPopupDelegate {
    func showFcPopup(hand: [Card], scene: GameScene)
}

protocol optionsMenuPopupDelegate {
    func showOptionsMenuPopup(scene: GameScene)
}
