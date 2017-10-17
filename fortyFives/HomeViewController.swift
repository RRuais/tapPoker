//
//  HomeViewController.swift
//  fortyFives
//
//  Created by Rich Ruais on 10/3/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.
//

import UIKit
import SpriteKit
import Firebase
import FirebaseDatabase
import FBSDKLoginKit
import FBSDKCoreKit
import SwiftyJSON
import SDWebImage
import SCLAlertView
import NVActivityIndicatorView
import SpriteKit
import NotificationBannerSwift

class HomeViewController: UIViewController, GADRewardBasedVideoAdDelegate {

    @IBOutlet weak var startGameBtn: UIButton!
    @IBOutlet weak var FBLoginButton: UIButton!
    @IBOutlet weak var achievementsButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    var indicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    var darkView = UIView()
    @IBOutlet weak var felt: UIImageView!
    @IBOutlet weak var sceneView: SKView!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var banner1: GADBannerView!
    let request = GADRequest()
    @IBOutlet weak var videoBonusBtn: UIButton!
    @IBOutlet weak var videoBonusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Silence Auto layout warnings
        UserDefaults.standard.setValue(false, forKey:"_UIConstraintBasedLayoutLogUnsatisfiable")
        
        self.checkLoginStatus()
    
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        userImage.layer.cornerRadius = 25
        userImage.layer.borderWidth = 1
        userImage.clipsToBounds = true
        userImage.contentMode = .scaleAspectFit

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.signOutActionImage))
        userImage.addGestureRecognizer(tapGesture)
        startGameBtn.clipsToBounds = true
        startGameBtn.setTitle("        Start Game", for: .normal)
        startGameBtn.layer.zPosition = 1
        achievementsButton.clipsToBounds = true
        achievementsButton.setTitle("        Achievements", for: .normal)
        achievementsButton.layer.zPosition = 1
        FBLoginButton.layer.zPosition = 1
        
        // Start Card Animation
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
        
        banner1.adUnitID = testAd
        banner1.rootViewController = self
        banner1.load(request)
        
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                    withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        logo.center.y += view.bounds.height
        achievementsButton.center.x -= view.bounds.width
        startGameBtn.center.x += view.bounds.width
        logo.isHidden = false
        achievementsButton.isHidden = false
        startGameBtn.isHidden = false
        UIView.animate(withDuration: 1, delay: 0.1,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0.5,
                       options: [], animations: {
                        self.logo.center.y -= self.view.bounds.height
                        self.achievementsButton.center.x += self.view.bounds.width
                        self.startGameBtn.center.x -= self.view.bounds.width
        }, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        logo.isHidden = true
        achievementsButton.isHidden = true
        startGameBtn.isHidden = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func checkLoginStatus() {
        if Auth.auth().currentUser != nil {
            // Indicator View
            darkView.backgroundColor = UIColor.black
            darkView.alpha = 0.5
            darkView.frame = self.view.frame
            self.view.addSubview(darkView)
            self.indicatorView = NVActivityIndicatorView(frame: CGRect(x: 50, y: 100, width: self.view.frame.size.width / 1.5, height: self.view.frame.size.height / 1.5))
            self.indicatorView.type = .ballSpinFadeLoader
            self.view.addSubview(self.indicatorView)
            self.indicatorView.startAnimating()
            
            print("Should be User")
            FBLoginButton.isHidden = true
            banner1.isHidden = false
            userImage.isUserInteractionEnabled = true
            achievementsButton.isEnabled = true
            videoBonusBtn.isHidden = false
            videoBonusLabel.isHidden = false
            checkFirstTimeUser()
        } else {
            print("No User")
            FBLoginButton.isHidden = false
            banner1.isHidden = true
            userImage.isUserInteractionEnabled = false
        
            achievementsButton.isEnabled = false
            videoBonusBtn.isHidden = true
            videoBonusLabel.isHidden = true
            userImage.image = UIImage(named: "placeholder")
            userName.text = "Logged in as Guest"
            pointsLabel.text = "0"
        }
    }
    
    
    func checkFirstTimeUser() {
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.hasChild(userID!) {
                print("First time user")
                self.setupFirstTimeUser()
            } else {
                print("Not a first time user")
                self.getFBInfo(completion: { (success) -> Void in
                    self.getUserAchievements()
                })
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
   

    func setupFirstTimeUser() {
        self.getFBInfo(completion: { (success) -> Void in
            if success {
                let imageString = UserDefaults.standard.value(forKey: "facebookImage") as! String
                let currentUser = Auth.auth().currentUser
                let ref = Database.database().reference()
                let achievements = Achievements()
                let newUserAchievements: [String : Bool] = [
                    "getPair" : achievements.getPair.0 as Bool,
                    "gettwoPair" : achievements.getTwoPair.0 as Bool,
                    "getthreeOfKind" : achievements.getThreeOfKind.0 as Bool,
                    "getStraight" : achievements.getStraight.0 as Bool,
                    "getFlush" : achievements.getFlush.0 as Bool,
                    "getFullHouse" : achievements.getFullHouse.0 as Bool,
                    "getFourOfKind" : achievements.getFourOfKind.0 as Bool,
                    "getStraightFlush" : achievements.getStraightFlush.0 as Bool,
                    "getRoyalFlush" : achievements.getRoyalFlush.0 as Bool,
                    "getAllHandsInSingleGame" : achievements.getAllHandsInSingleGame.0 as Bool,
                    "reach50Pairs" : achievements.reach50Pairs.0 as Bool,
                    "reach50TwoPairs" : achievements.reach50TwoPairs.0 as Bool,
                    "reach50ThreeOfKinds" : achievements.reach50ThreeOfKinds.0 as Bool,
                    "reach50Straights" : achievements.reach50Straights.0 as Bool,
                    "reach50Flushes" : achievements.reach50Flushes.0 as Bool,
                    "reach50FullHouses" : achievements.reach50FullHouses.0 as Bool,
                    "reach50FourOfKinds" : achievements.reach50FourOfKinds.0 as Bool,
                    "reach50StraightFlushes" : achievements.reach50StraightFlushes.0 as Bool,
                    "reach50RoyalFlushes" : achievements.reach50RoyalFlushes.0 as Bool,
                    ]
                ref.child("users").child((currentUser?.uid)!).setValue([
                    "userName": currentUser?.displayName! as Any,
                    "imageString": imageString,
                    "gameHistory" : [
                        "Pair" : 0,
                        "Two Pair" : 0,
                        "Three of a Kind" : 0,
                        "Straight" : 0,
                        "Flush" : 0,
                        "Full House" : 0,
                        "Four of a Kind" : 0,
                        "Straight Flush" : 0,
                        "Royal Flush" : 0,
                        "Points" : 500,
                        "Lifetime Points" : 0,
                        "Best Score" : 0
                    ],
                    "newUserAchievements" : newUserAchievements
                    ])
                self.getUserAchievements()
            }
        })
    }

    
    @IBAction func start(_ sender: UIButton) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectGameViewController") as? SelectGameViewController {
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    func showAchievementsView() {
        if let viewController = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "ContainerViewController") as? ContainerViewController {
            self.present(viewController, animated: true, completion: nil)
        }
    }


    @IBAction func achievementsAction(_ sender: UIButton) {
        showAchievementsView()
    }
  
    func signOutActionImage() {
        let appearance = SCLAlertView.SCLAppearance(
            kCircleHeight: 50,
            kCircleIconHeight: 50,
            buttonCornerRadius : 10
           )
        let alertView = SCLAlertView(appearance: appearance)
        let imageString = UserDefaults.standard.value(forKey: "facebookImage") as! String
        let alertViewIcon = UIImageView()
        alertViewIcon.sd_setImage(with: URL(string: imageString), placeholderImage: UIImage(named: "placeholder"))
        alertView.addButton("Sign Out", target:self, selector:#selector(HomeViewController.signOut))
        alertView.addButton("Feedback", target:self, selector:#selector(HomeViewController.showFeedbackVc))
        alertView.showError("Tap Poker", subTitle: "", circleIconImage: alertViewIcon.image)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            checkLoginStatus()
        } catch {
            print("Error Logging out \(error.localizedDescription)")
        }
    }
    
    func showFeedbackVc() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedbackViewController") as? FeedbackViewController {
            self.present(viewController, animated: true, completion: nil)
        }
    }

    @IBAction func facebookLogin(sender: UIButton) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                self.checkLoginStatus()
                // Present the main view
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") {
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }   
    }
    
    func getUserAchievements() {
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let gameHistory = value?["gameHistory"] as? [String:Any] {
                let pair = gameHistory["Pair"] as? Int
                let twoPair = gameHistory["Two Pair"] as? Int
                let threeofKind = gameHistory["Three of a Kind"] as? Int
                let straight = gameHistory["Straight"] as? Int
                let flush = gameHistory["Flush"] as? Int
                let fullHouse = gameHistory["Full House"] as? Int
                let fourOfKind = gameHistory["Four of a Kind"] as? Int
                let straightFlush = gameHistory["Straight Flush"] as? Int
                let royalFlush = gameHistory["Royal Flush"] as? Int
                let points = gameHistory["Points"] as? Int
                let lifetimePoints = gameHistory["Lifetime Points"] as? Int
                let bestScore = gameHistory["Best Score"] as? Int
                var userGameHistory = [
                    "Pair" : pair!,
                    "Two Pair" : twoPair!,
                    "Three of a Kind" : threeofKind!,
                    "Straight" : straight!,
                    "Flush" : flush!,
                    "Full House" : fullHouse!,
                    "Four of a Kind" : fourOfKind!,
                    "Straight Flush" : straightFlush!,
                    "Royal Flush" : royalFlush!,
                    "Points" : points,
                    "Lifetime Points" : lifetimePoints,
                    "Best Score" : bestScore
                ]
                UserDefaults.standard.set(userGameHistory, forKey: "userGameHistory")
                self.pointsLabel.text = "\(String(describing: points!))"
            }
            if let achievements = value?["newUserAchievements"] as? [String:Bool] {
                let newUserAchievements = [
                    "getPair" : achievements["getPair"],
                    "gettwoPair" : achievements["gettwoPair"],
                    "getthreeOfKind" : achievements["getthreeOfKind"],
                    "getStraight" : achievements["getStraight"],
                    "getFlush" : achievements["getFlush"],
                    "getFullHouse" : achievements["getFullHouse"],
                    "getFourOfKind" : achievements["getFourOfKind"],
                    "getStraightFlush" : achievements["getStraightFlush"],
                    "getRoyalFlush" : achievements["getRoyalFlush"],
                    "getAllHandsInSingleGame" : achievements["getAllHandsInSingleGame"],
                    "reach50Pairs" : achievements["reach50Pairs"],
                    "reach50TwoPairs" : achievements["reach50TwoPairs"],
                    "reach50ThreeOfKinds" : achievements["reach50ThreeOfKinds"],
                    "reach50Straights" : achievements["reach50Straights"],
                    "reach50Flushes" : achievements["reach50Flushes"],
                    "reach50FullHouses" : achievements["reach50FullHouses"],
                    "reach50FourOfKinds" : achievements["reach50FourOfKinds"],
                    "reach50StraightFlushes" : achievements["reach50StraightFlushes"],
                    "reach50RoyalFlushes" : achievements["reach50RoyalFlushes"]
                ]
                UserDefaults.standard.set(newUserAchievements, forKey: "newUserAchievements")
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getFBInfo(completion: @escaping (_ success: Bool) -> Void) {
        let facebook = Facebook()
        facebook.getFBInfo() { (success) -> Void in
            if success {
                let name = UserDefaults.standard.value(forKey: "facebookName")
                let unwrappedName = name as! String
                self.userName.text = name as! String
                let imageString = UserDefaults.standard.value(forKey: "facebookImage") as! String
                self.userImage.sd_setImage(with: URL(string: imageString), placeholderImage: UIImage(named: "placeholder"))
                self.indicatorView.stopAnimating()
                self.darkView.removeFromSuperview()
                completion(true)
            }
        }
    }
    
    
    @IBAction func showVideoAd(_ sender: UIButton) {
        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        }
    }
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
        print("Reward received with currency:, amount.")
        let user = Auth.auth().currentUser
        let ref = Database.database().reference()
        var userGameHistory = UserDefaults.standard.value(forKey: "userGameHistory") as? [String:Any]
        let points = userGameHistory?["Points"] as! Int
        print("Points +++ \(points)")
        let newPoints = points + 100
        print("NewPoints +++ \(newPoints)")
        userGameHistory?["Points"] = newPoints
        print("gameHistoryPoints +++ \(String(describing: userGameHistory?["Points"]))")
        ref.child("users").child((user?.uid)!).child("gameHistory").setValue(userGameHistory)
        self.getUserAchievements()
        self.videoBonusBtn.isHidden = true
        self.videoBonusLabel.isHidden = true
    }
  
    @IBAction func unwindToHome(segue:UIStoryboardSegue) {
        if Auth.auth().currentUser != nil {
            getUserAchievements()
        }
    }
    
}
