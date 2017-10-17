//
//  OptionsMenuViewController.swift
//  fortyFives
//
//  Created by Rich Ruais on 10/5/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.
//

import UIKit

class OptionsMenuViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var quitGameButton: UIStackView!
    @IBOutlet weak var resumeGameButton: UIButton!
    
    var parentVc: ViewController?
    var scene: GameScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layer.cornerRadius = 20
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func quit(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToHome", sender: self)
    }
    
    @IBAction func resume(_ sender: UIButton) {
        if !(scene?.gameIsStarted)! {
        print("Game Not Started \(scene?.gameIsStarted)")
            self.dismiss(animated: true, completion: nil)
        } else {
            print("Game Started \(scene?.gameIsStarted)")
           scene?.resumeGame()
           self.dismiss(animated: true, completion: nil)
        }
    }
    
}
