//
//  ViewController.swift
//  fortyFives
//
//  Created by Rich Ruais on 9/26/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.
//

import UIKit
import SpriteKit
import Presentr

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate, GameOverDelegate, FreeCardPopupDelegate, optionsMenuPopupDelegate , SKViewDelegate {

    var gameDifficulty = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                scene.scaleMode = .resizeFill
                // Present the scene
                scene.goDelegate = self
                scene.fcDelegate = self
                scene.omDelegate = self
                scene.gameDifficulty = gameDifficulty
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
//            view.showsFPS = true
//            view.showsNodeCount = true
        }
    }
    
 
    
    func gameOver(result: FinalScore) {
        print("RESULT IN GAMEOVER +++ \(result)")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GameOverViewController") as! GameOverViewController
        vc.pair = result.pair
        vc.twoPair = result.twoPair
        vc.threeKind = result.threeKind
        vc.straight = result.straight
        vc.flush = result.flush
        vc.fullHouse = result.fullHouse
        vc.fourKind = result.fourKind
        vc.straightFlush = result.straightFlush
        vc.royalFlush = result.royalFlush
        vc.totalPoints = result.totalPoints
//        vc.hand = result.1 
//        vc.titleHand = result.0 
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor = UIColor.clear
        present(vc, animated: true, completion: nil)
    }
    
    func showFcPopup(hand: [Card], scene: GameScene) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FreeCardPopupViewController") as! FreeCardPopupViewController
        vc.hand = hand
        vc.scene = scene
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor = UIColor.clear
        present(vc, animated: true, completion: nil)
    }
    
    func showOptionsMenuPopup(scene: GameScene) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OptionsMenuViewController") as! OptionsMenuViewController
        vc.scene = scene
        vc.parentVc = self
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor = UIColor.clear
        present(vc, animated: true, completion: nil)
    }
    
    func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
