//
//  FreeCardPopupViewController.swift
//  fortyFives
//
//  Created by Rich Ruais on 10/5/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.
//

import UIKit
import SpriteKit

class FreeCardPopupViewController: UIViewController {

    @IBOutlet weak var freeCard1: UIImageView!
    @IBOutlet weak var freeCard2: UIImageView!
    @IBOutlet weak var freeCard3: UIImageView!
    @IBOutlet weak var freeCard4: UIImageView!
    @IBOutlet weak var freeCard5: UIImageView!
    @IBOutlet weak var freeCard6: UIImageView!
    @IBOutlet weak var freeCard7: UIImageView!
    @IBOutlet weak var freeCard8: UIImageView!
    @IBOutlet weak var freeCard9: UIImageView!
    @IBOutlet weak var freeCard10: UIImageView!
    @IBOutlet weak var mainView: UIView!
    
    let playingCard = PlayingCard()
    var hand: [Card]?
    var scene: GameScene?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCardViews()
        
        mainView.layer.cornerRadius = 20
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    func setupCardViews() {
        var deck = playingCard.createDeck()
        for card in hand! {
            if deck.contains(card) {
                let index = deck.index(of: card)
                deck.remove(at: index!)
            }
        }
        let rand1 = randomIndexForArray(array: deck)
        freeCard1.image = UIImage(named: deck[rand1].imageName)
        freeCard1.isUserInteractionEnabled = true
        let tapgesture1 = MyTapGestureRecognizer(card: deck[rand1], target: self, action: #selector(FreeCardPopupViewController.tapFreeCard(gestureRecognizer:)))
        freeCard1.addGestureRecognizer(tapgesture1)
        deck.remove(at: rand1)
        
        let rand2 = randomIndexForArray(array: deck)
        freeCard2.image = UIImage(named: deck[rand2].imageName)
        freeCard2.isUserInteractionEnabled = true
        let tapgesture2 = MyTapGestureRecognizer(card: deck[rand2], target: self, action: #selector(FreeCardPopupViewController.tapFreeCard(gestureRecognizer:)))
        freeCard2.addGestureRecognizer(tapgesture2)
        deck.remove(at: rand2)
        
        let rand3 = randomIndexForArray(array: deck)
        freeCard3.image = UIImage(named: deck[rand3].imageName)
        freeCard3.isUserInteractionEnabled = true
        let tapgesture3 = MyTapGestureRecognizer(card: deck[rand3], target: self, action: #selector(FreeCardPopupViewController.tapFreeCard(gestureRecognizer:)))
        freeCard3.addGestureRecognizer(tapgesture3)
        deck.remove(at: rand3)
        
        let rand4 = randomIndexForArray(array: deck)
        freeCard4.image = UIImage(named: deck[rand4].imageName)
        freeCard4.isUserInteractionEnabled = true
        let tapgesture4 = MyTapGestureRecognizer(card: deck[rand4], target: self, action: #selector(FreeCardPopupViewController.tapFreeCard(gestureRecognizer:)))
        freeCard4.addGestureRecognizer(tapgesture4)
        deck.remove(at: rand4)
        
        let rand5 = randomIndexForArray(array: deck)
        freeCard5.image = UIImage(named: deck[rand5].imageName)
        freeCard5.isUserInteractionEnabled = true
        let tapgesture5 = MyTapGestureRecognizer(card: deck[rand5], target: self, action: #selector(FreeCardPopupViewController.tapFreeCard(gestureRecognizer:)))
        freeCard5.addGestureRecognizer(tapgesture5)
        deck.remove(at: rand5)
        
        let rand6 = randomIndexForArray(array: deck)
        freeCard6.image = UIImage(named: deck[rand6].imageName)
        freeCard6.isUserInteractionEnabled = true
        let tapgesture6 = MyTapGestureRecognizer(card: deck[rand6], target: self, action: #selector(FreeCardPopupViewController.tapFreeCard(gestureRecognizer:)))
        freeCard6.addGestureRecognizer(tapgesture6)
        deck.remove(at: rand6)
        
        let rand7 = randomIndexForArray(array: deck)
        freeCard7.image = UIImage(named: deck[rand7].imageName)
        freeCard7.isUserInteractionEnabled = true
        let tapgesture7 = MyTapGestureRecognizer(card: deck[rand7], target: self, action: #selector(FreeCardPopupViewController.tapFreeCard(gestureRecognizer:)))
        freeCard7.addGestureRecognizer(tapgesture7)
        deck.remove(at: rand7)
        
        let rand8 = randomIndexForArray(array: deck)
        freeCard8.image = UIImage(named: deck[rand8].imageName)
        freeCard8.isUserInteractionEnabled = true
        let tapgesture8 = MyTapGestureRecognizer(card: deck[rand8], target: self, action: #selector(FreeCardPopupViewController.tapFreeCard(gestureRecognizer:)))
        freeCard8.addGestureRecognizer(tapgesture8)
        deck.remove(at: rand8)
        
        let rand9 = randomIndexForArray(array: deck)
        freeCard9.image = UIImage(named: deck[rand9].imageName)
        freeCard9.isUserInteractionEnabled = true
        let tapgesture9 = MyTapGestureRecognizer(card: deck[rand9], target: self, action: #selector(FreeCardPopupViewController.tapFreeCard(gestureRecognizer:)))
        freeCard9.addGestureRecognizer(tapgesture9)
        deck.remove(at: rand9)

        let rand10 = randomIndexForArray(array: deck)
        freeCard10.image = UIImage(named: deck[rand10].imageName)
        freeCard10.isUserInteractionEnabled = true
        let tapgesture10 = MyTapGestureRecognizer(card: deck[rand10], target: self, action: #selector(FreeCardPopupViewController.tapFreeCard(gestureRecognizer:)))
        freeCard10.addGestureRecognizer(tapgesture10)
        deck.remove(at: rand10)
        
    }
    
    func tapFreeCard(gestureRecognizer: MyTapGestureRecognizer) {
        if let card = gestureRecognizer.card {
            let cardNode = CardNode(imageName: card.imageName, playingCard: card)
            scene?.assignAnswer(cardTouched: cardNode)
            scene?.resumeGame()
            self.dismiss(animated: true, completion: nil)
        }
       
    }
    
    @IBAction func close(_ sender: UIButton) {
        scene?.resumeGame()
        self.dismiss(animated: true, completion: nil)
    }
}

class MyTapGestureRecognizer: UITapGestureRecognizer {
    var card: Card?
    init(card: Card, target: Any, action: Selector) {
        self.card = card
        super.init(target: target, action: action)
    }
}
