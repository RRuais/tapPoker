//
//  GameOverViewController.swift
//  fortyFives
//
//  Created by Rich Ruais on 10/1/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import NotificationBannerSwift

class GameOverViewController: UIViewController, GADInterstitialDelegate {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var continueBtnLbl: UIButton!
    @IBOutlet weak var pairLabel: UILabel!
    @IBOutlet weak var twoPairLabel: UILabel!
    @IBOutlet weak var threeKindLabel: UILabel!
    @IBOutlet weak var straightLabel: UILabel!
    @IBOutlet weak var flushLabel: UILabel!
    @IBOutlet weak var fullHouseLabel: UILabel!
    @IBOutlet weak var fourKindLabel: UILabel!
    @IBOutlet weak var straightFlushLabel: UILabel!
    @IBOutlet weak var royalFlushLabel: UILabel!
    @IBOutlet weak var totalPointsLabel: UILabel!
    
    var pair = 0
    var twoPair = 0
    var threeKind = 0
    var straight = 0
    var flush = 0
    var fullHouse = 0
    var fourKind = 0
    var straightFlush = 0
    var royalFlush = 0
    var totalPoints = 0
    var pointsBeforeAchievements = 0
    
    var titleHand = String()
    var hand = [Card]()
    
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        let request = GADRequest()
        interstitial.load(request)

        mainView.layer.cornerRadius = 20
        
        let effect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: effect)
        blurView.frame = self.view.bounds
        self.view.addSubview(blurView)
        self.view.addSubview(mainView)
        
        
        pairLabel.text = "\(pair)"
        twoPairLabel.text = "\(twoPair)"
        threeKindLabel.text = "\(threeKind)"
        straightLabel.text = "\(straight)"
        flushLabel.text = "\(flush)"
        fullHouseLabel.text = "\(fullHouse)"
        fourKindLabel.text = "\(fourKind)"
        straightFlushLabel.text = "\(straightFlush)"
        royalFlushLabel.text = "\(royalFlush)"
        totalPointsLabel.text = "\(totalPoints)"
        
        // If User then save score
        if Auth.auth().currentUser != nil {
            self.checkGameHistoryAchievements()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func displayBanner(title: String) {
        ("Display")
        let banner = NotificationBanner(title: "Congratulations!", subtitle: title, style: .info)
        banner.show(bannerPosition: .top, on: self)
        banner.bannerHeight = 100
        banner.layer.zPosition = 1
        banner.autoDismiss = false
        banner.onTap = {
            banner.dismiss()
            self.totalPointsLabel.text = "\(self.totalPoints)"
        }
    }
    
    func checkGameHistoryAchievements() {
        
        pointsBeforeAchievements = totalPoints
        
        let user = Auth.auth().currentUser
        let ref = Database.database().reference()
        //// Check for achievements
        let achievements = UserDefaults.standard.value(forKey: "newUserAchievements") as? [String:Bool]
        var newUserAchievements = Achievements()
        newUserAchievements.getPair.0 = (achievements?["getPair"])!
        newUserAchievements.getTwoPair.0 = (achievements?["gettwoPair"])!
        newUserAchievements.getThreeOfKind.0 = (achievements?["getthreeOfKind"]!)!
        newUserAchievements.getStraight.0 = (achievements?["getStraight"]!)!
        newUserAchievements.getFlush.0 = (achievements?["getFlush"])!
        newUserAchievements.getFullHouse.0 = (achievements?["getFullHouse"])!
        newUserAchievements.getFourOfKind.0 = (achievements?["getFourOfKind"])!
        newUserAchievements.getStraightFlush.0 = (achievements?["getStraightFlush"])!
        newUserAchievements.getRoyalFlush.0 = (achievements?["getRoyalFlush"]!)!
        newUserAchievements.getAllHandsInSingleGame.0 = (achievements?["getAllHandsInSingleGame"]!)!
        newUserAchievements.reach50Pairs.0 = (achievements?["reach50Pairs"]!)!
        newUserAchievements.reach50TwoPairs.0 = (achievements?["reach50TwoPairs"]!)!
        newUserAchievements.reach50ThreeOfKinds.0 = (achievements?["reach50ThreeOfKinds"]!)!
        newUserAchievements.reach50Straights.0 = (achievements?["reach50Straights"]!)!
        newUserAchievements.reach50Flushes.0 = (achievements?["reach50Flushes"]!)!
        newUserAchievements.reach50FullHouses.0 = (achievements?["reach50FullHouses"]!)!
        newUserAchievements.reach50FourOfKinds.0 = (achievements?["reach50FourOfKinds"]!)!
        newUserAchievements.reach50StraightFlushes.0 = (achievements?["reach50StraightFlushes"]!)!
        newUserAchievements.reach50RoyalFlushes.0 = (achievements?["reach50RoyalFlushes"]!)!

        if newUserAchievements.getPair.0 == false {
            print("Pair = False")
            if pair > 0 {
                newUserAchievements.getPair.0 = true
                totalPoints += newUserAchievements.getPair.1
                displayBanner(title: "You got a Pair! \(newUserAchievements.getPair.1) bonus points!")
            }
            
        }
        if newUserAchievements.getTwoPair.0 == false {
            print("twoPair = False")
            if twoPair > 0 {
                newUserAchievements.getTwoPair.0 = true
                totalPoints += newUserAchievements.getTwoPair.1
                displayBanner(title: "You got a Two Pair! \(newUserAchievements.getTwoPair.1) bonus points!")
            }
        }
        if newUserAchievements.getThreeOfKind.0 == false {
            print("threeKind = False")
            if threeKind > 0 {
                newUserAchievements.getThreeOfKind.0 = true
                totalPoints += newUserAchievements.getThreeOfKind.1
                displayBanner(title: "You got a Three of a Kind! \(newUserAchievements.getThreeOfKind.1) bonus points!")
            }
        }
        if newUserAchievements.getStraight.0 == false {
            print("straight = False")
            if straight > 0 {
                newUserAchievements.getStraight.0 = true
                totalPoints += newUserAchievements.getStraight.1
                displayBanner(title: "You got a Straight! \(newUserAchievements.getStraight.1) bonus points!")
            }
        }
        if newUserAchievements.getFlush.0 == false {
            print("Fluch = False")
            if flush > 0 {
                newUserAchievements.getFlush.0 = true
                totalPoints += newUserAchievements.getFlush.1
                displayBanner(title: "You got a Flush! \(newUserAchievements.getFlush.1) bonus points!")
            }
        }
        if newUserAchievements.getFullHouse.0 == false {
            print("fullHouse = False")
            if fullHouse > 0 {
                newUserAchievements.getFullHouse.0 = true
                totalPoints += newUserAchievements.getFullHouse.1
                displayBanner(title: "You got a Full House! \(newUserAchievements.getFullHouse.1) bonus points!")
            }
        }
        if newUserAchievements.getFourOfKind.0 == false {
            print("fourKind = False")
            if fourKind > 0 {
                newUserAchievements.getFourOfKind.0 = true
                totalPoints += newUserAchievements.getFourOfKind.1
                displayBanner(title: "You got a Four of a Kind! \(newUserAchievements.getFourOfKind.1) bonus points!")
            }
        }
        if newUserAchievements.getStraightFlush.0 == false {
            print("straightFlush = False")
            if straightFlush > 0 {
                newUserAchievements.getStraightFlush.0 = true
                totalPoints += newUserAchievements.getStraightFlush.1
                displayBanner(title: "You got a Straight Flush! \(newUserAchievements.getStraightFlush.1) bonus points!")
            }
        }
        if newUserAchievements.getRoyalFlush.0 == false {
            print("royalFlush = False")
            if royalFlush > 0 {
                newUserAchievements.getRoyalFlush.0 = true
                totalPoints += newUserAchievements.getRoyalFlush.1
                displayBanner(title: "You got a Royal Flush! \(newUserAchievements.getRoyalFlush.1) bonus points!")
            }
        }
        if newUserAchievements.getAllHandsInSingleGame.0 == false {
            print("getAllHandsInSingleGame = False")
            if pair > 0 && twoPair > 0 && threeKind > 0 && straight > 0 && flush > 0 && fullHouse > 0 && fourKind > 0 && straightFlush > 0 && royalFlush > 0 {
                newUserAchievements.getAllHandsInSingleGame.0 = true
                totalPoints += newUserAchievements.getAllHandsInSingleGame.1
                displayBanner(title: "You got all hands in a single game! \(newUserAchievements.getAllHandsInSingleGame.1) bonus points!")
            }
        }
        if newUserAchievements.reach50Pairs.0 == false {
            print("Pair = False")
            if pair > 49 {
                newUserAchievements.reach50Pairs.0 = true
                totalPoints += newUserAchievements.reach50Pairs.1
                displayBanner(title: "You reached 50 Pairs! \(newUserAchievements.reach50Pairs.1) bonus points!")
            }
        }
        if newUserAchievements.reach50TwoPairs.0 == false {
            print("twoPair = False")
            if twoPair > 49 {
                newUserAchievements.reach50TwoPairs.0 = true
                totalPoints += newUserAchievements.reach50TwoPairs.1
                displayBanner(title: "You reached 50 Two Pairs! \(newUserAchievements.reach50TwoPairs.1) bonus points!")
            }
        }
        if newUserAchievements.reach50ThreeOfKinds.0 == false {
            print("threeKind = False")
            if threeKind > 49 {
                newUserAchievements.reach50ThreeOfKinds.0 = true
                totalPoints += newUserAchievements.reach50ThreeOfKinds.1
                displayBanner(title: "You reached 50 Three of a Kind! \(newUserAchievements.reach50ThreeOfKinds.1) bonus points!")
            }
        }
        if newUserAchievements.reach50Straights.0 == false {
            print("straight = False")
            if straight > 49 {
                newUserAchievements.reach50Straights.0 = true
                totalPoints += newUserAchievements.reach50Straights.1
                displayBanner(title: "You reached 50 Straights! \(newUserAchievements.reach50Straights.1) bonus points!")
            }
        }
        if newUserAchievements.reach50Flushes.0 == false {
            print("Fluch = False")
            if flush > 49 {
                newUserAchievements.reach50Flushes.0 = true
                totalPoints += newUserAchievements.reach50Flushes.1
                displayBanner(title: "You reached 50 Flushes! \(newUserAchievements.reach50Flushes.1) bonus points!")
            }
        }
        if newUserAchievements.reach50FullHouses.0 == false {
            print("fullHouse = False")
            if fullHouse > 49 {
                newUserAchievements.reach50FullHouses.0 = true
                totalPoints += newUserAchievements.reach50FullHouses.1
                displayBanner(title: "You reached 50 Full Houses! \(newUserAchievements.reach50FullHouses.1) bonus points!")
            }
        }
        if newUserAchievements.reach50FourOfKinds.0 == false {
            print("fourKind = False")
            if fourKind > 49 {
                newUserAchievements.reach50FourOfKinds.0 = true
                totalPoints += newUserAchievements.reach50FourOfKinds.1
                displayBanner(title: "You reached 50 Four of a kind! \(newUserAchievements.reach50FourOfKinds.1) bonus points!")
            }
        }
        if newUserAchievements.reach50StraightFlushes.0 == false {
            print("straightFlush = False")
            if straightFlush > 49 {
                newUserAchievements.reach50StraightFlushes.0 = true
                totalPoints += newUserAchievements.reach50StraightFlushes.1
                displayBanner(title: "You reached 50 Straight Flushes! \(newUserAchievements.reach50StraightFlushes.1) bonus points!")
            }
        }
        if newUserAchievements.reach50RoyalFlushes.0 == false {
            print("royalFlush = False")
            if royalFlush > 49 {
                newUserAchievements.reach50RoyalFlushes.0 = true
                totalPoints += newUserAchievements.reach50RoyalFlushes.1
                displayBanner(title: "You reached 50 Royal Flushes! \(newUserAchievements.reach50RoyalFlushes.1) bonus points!")
            }
        }
        // Save to dB
        let achievementsToSave: [String : Bool] = [
            "getPair" : newUserAchievements.getPair.0 as Bool,
            "gettwoPair" : newUserAchievements.getTwoPair.0 as Bool,
            "getthreeOfKind" : newUserAchievements.getThreeOfKind.0 as Bool,
            "getStraight" : newUserAchievements.getStraight.0 as Bool,
            "getFlush" : newUserAchievements.getFlush.0 as Bool,
            "getFullHouse" : newUserAchievements.getFullHouse.0 as Bool,
            "getFourOfKind" : newUserAchievements.getFourOfKind.0 as Bool,
            "getStraightFlush" : newUserAchievements.getStraightFlush.0 as Bool,
            "getRoyalFlush" : newUserAchievements.getRoyalFlush.0 as Bool,
            "getAllHandsInSingleGame" : newUserAchievements.getAllHandsInSingleGame.0 as Bool,
            "reach50Pairs" : newUserAchievements.reach50Pairs.0 as Bool,
            "reach50TwoPairs" : newUserAchievements.reach50TwoPairs.0 as Bool,
            "reach50ThreeOfKinds" : newUserAchievements.reach50ThreeOfKinds.0 as Bool,
            "reach50Straights" : newUserAchievements.reach50Straights.0 as Bool,
            "reach50Flushes" : newUserAchievements.reach50Flushes.0 as Bool,
            "reach50FullHouses" : newUserAchievements.reach50FullHouses.0 as Bool,
            "reach50FourOfKinds" : newUserAchievements.reach50FourOfKinds.0 as Bool,
            "reach50StraightFlushes" : newUserAchievements.reach50StraightFlushes.0 as Bool,
            "reach50RoyalFlushes" : newUserAchievements.reach50RoyalFlushes.0 as Bool
        ]
        ref.child("users").child((user?.uid)!).child("newUserAchievements").setValue(achievementsToSave)
        // Save to local variable
        UserDefaults.standard.set(achievementsToSave, forKey: "newUserAchievements")
        print("achievements +++ \(String(describing: achievementsToSave))")
        
        // Calculate score
        var userGameHistory = UserDefaults.standard.value(forKey: "userGameHistory") as? [String:Any]
        print("GameHistory UserDefaults  +++ \(userGameHistory)")
        var newUserGameHistory = [
            "Pair" : pair + Int(userGameHistory?["Pair"] as! Int),
            "Two Pair" : twoPair + Int(userGameHistory?["Two Pair"] as! Int),
            "Three of a Kind" : threeKind + Int(userGameHistory?["Three of a Kind"] as! Int),
            "Straight" : straight + Int(userGameHistory?["Straight"] as! Int),
            "Flush" : flush + Int(userGameHistory?["Flush"] as! Int),
            "Full House" : fullHouse + Int(userGameHistory?["Full House"] as! Int),
            "Four of a Kind" : fourKind + Int(userGameHistory?["Four of a Kind"] as! Int),
            "Straight Flush" : straightFlush + Int(userGameHistory?["Straight Flush"] as! Int),
            "Royal Flush" : royalFlush + Int(userGameHistory?["Royal Flush"] as! Int),
            "Points" : totalPoints + Int(userGameHistory?["Points"] as! Int),
            "Lifetime Points" : totalPoints + Int(userGameHistory?["Lifetime Points"] as! Int),
            "Best Score" : Int(userGameHistory?["Best Score"] as! Int)
        ]
        
        
        
        let bestScore = Int(userGameHistory?["Best Score"] as! Int)
        if pointsBeforeAchievements > bestScore {
            newUserGameHistory["Best Score"] = totalPoints
        }
        
        // Save score to dB
        ref.child("users").child((user?.uid)!).child("gameHistory").setValue(newUserGameHistory)
        // Save score to local variable
        UserDefaults.standard.set(newUserGameHistory, forKey: "userGameHistory")
    }

    @IBAction func close(_ sender: UIButton) {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    func doneWithAd() {
         performSegue(withIdentifier: "unwindToHome", sender: self)
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
        self.doneWithAd()
    }
    
}
