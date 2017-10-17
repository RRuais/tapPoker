//
//  SelectGameViewController.swift
//  fortyFives
//
//  Created by Rich Ruais on 10/6/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseDatabase
import SpriteKit

class SelectGameViewController: UIViewController {
    
    @IBOutlet weak var game1Btn: UIButton!
    @IBOutlet weak var game2Btn: UIButton!
    @IBOutlet weak var game3Btn: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var sceneView: SKView!
    @IBOutlet weak var felt: UIImageView!
    @IBOutlet weak var banner2: GADBannerView!
    @IBOutlet weak var instructionsBtn: UIButton!
    
    let request = GADRequest()
    
    var name = String()
    var imageString = String()
    var userGameHistory = [String:Any]()
    var points = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUser()
        game1Btn.layer.cornerRadius = 10
        game2Btn.layer.cornerRadius = 10
        game2Btn.setTitle("         Medium - 400", for: .normal)
        game3Btn.layer.cornerRadius = 10
        game3Btn.setTitle("     Hard - 800", for: .normal)
        userImage.layer.cornerRadius = 25
        userImage.layer.borderWidth = 1
        userImage.clipsToBounds = true
        userImage.contentMode = .scaleAspectFit
        userName.text = name as? String
        pointsLabel.text = "\(points)"
        
        if let sceneView = sceneView as SKView? {
            if let scene = SKScene(fileNamed: "IntroScene") as? IntroScene {
                scene.scaleMode = .resizeFill
                // Present the scene
                sceneView.presentScene(scene)
            }
            sceneView.ignoresSiblingOrder = true
        }
        sceneView.allowsTransparency = true
        sceneView.scene?.backgroundColor = UIColor.clear
        sceneView.layer.zPosition = -1
        felt.layer.zPosition = -2
        self.view.addSubview(sceneView)
        
        banner2.adUnitID = testAd
        banner2.rootViewController = self
        banner2.load(request)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func checkIfUser() {
        if Auth.auth().currentUser != nil {
            name = UserDefaults.standard.value(forKey: "facebookName") as! String
            imageString = UserDefaults.standard.value(forKey: "facebookImage") as! String
            userGameHistory = (UserDefaults.standard.value(forKey: "userGameHistory") as? [String:Any])!
            points = (userGameHistory["Points"] as? Int)!
            userImage.sd_setImage(with: URL(string: imageString ), placeholderImage: UIImage(named: "placeholder"))
            game1Btn.setTitle("     Easy - 200", for: .normal)
            checkPoints()
        } else {
            userImage.image = UIImage(named: "placeholder")
            points = 0
            game2Btn.isEnabled = false
            game3Btn.isEnabled = false
            game1Btn.setTitle("     Practice", for: .normal)
        }
    }
    
    func checkPoints() {
        print("Points +++ \(points)")
        if points >= 200 {
            game1Btn.isEnabled = true
        } else {
            game1Btn.isEnabled = false
        }
        if points >= 400 {
            game2Btn.isEnabled = true
        } else {
            game2Btn.isEnabled = false
        }
        if points >= 800 {
            print("Greater +++ \(points)")
            game3Btn.isEnabled = true
        } else {
            print("Less +++ \(points)")
            game3Btn.isEnabled = false
        }
    }

    @IBAction func startEasy(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            var userGameHistory = UserDefaults.standard.value(forKey: "userGameHistory") as? [String:Any]
            let oldPoints = userGameHistory?["Points"] as! Int
            let newPoints = oldPoints - 200
            let user = Auth.auth().currentUser
            let ref = Database.database().reference()
            ref.child("users").child((user?.uid)!).child("gameHistory").child("Points").setValue(newPoints)
            userGameHistory?["Points"] = newPoints
            UserDefaults.standard.set(userGameHistory, forKey: "userGameHistory")
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as? ViewController {
                viewController.gameDifficulty = "easy"
                self.present(viewController, animated: true, completion: nil)
            }
        } else {
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as? ViewController {
                viewController.gameDifficulty = "practice"
                self.present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func startMedium(_ sender: UIButton) {
        var userGameHistory = UserDefaults.standard.value(forKey: "userGameHistory") as? [String:Any]
        let oldPoints = userGameHistory?["Points"] as! Int
        let newPoints = oldPoints - 400
        let user = Auth.auth().currentUser
        let ref = Database.database().reference()
        ref.child("users").child((user?.uid)!).child("gameHistory").child("Points").setValue(newPoints)
        userGameHistory?["Points"] = newPoints
        UserDefaults.standard.set(userGameHistory, forKey: "userGameHistory")
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as? ViewController {
            viewController.gameDifficulty = "medium"
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func startHard(_ sender: UIButton) {
        var userGameHistory = UserDefaults.standard.value(forKey: "userGameHistory") as? [String:Any]
        let oldPoints = userGameHistory?["Points"] as! Int
        let newPoints = oldPoints - 800
        let user = Auth.auth().currentUser
        let ref = Database.database().reference()
        ref.child("users").child((user?.uid)!).child("gameHistory").child("Points").setValue(newPoints)
        userGameHistory?["Points"] = newPoints
        UserDefaults.standard.set(userGameHistory, forKey: "userGameHistory")
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as? ViewController {
            viewController.gameDifficulty = "hard"
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func showInstructions(_ sender: UIButton) {
        if let viewController = UIStoryboard(name: "Instructions", bundle: nil).instantiateViewController(withIdentifier: "InstructionsPageViewController") as? InstructionsPageViewController {
            self.present(viewController, animated: true, completion: nil)
        }

    }
    

    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
