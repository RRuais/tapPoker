//
//  AchievementsViewController.swift
//  fortyFives
//
//  Created by Rich Ruais on 10/4/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AchievementsViewController: UIViewController {
    
    @IBOutlet weak var achievementsTableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var banner4: GADBannerView!
    let request = GADRequest()
    
    var achieveKeys = ["","","","","","","","","","","","","","","","","","",""]
    var achieveValues = ["","","","","","","","","","","","","","","","","","",""]
    
    let achievements = UserDefaults.standard.value(forKey: "newUserAchievements") as? [String:Bool]
    
    let tempAchievements = Achievements()
    var bonusPoints = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

    override func viewDidLoad() {
        super.viewDidLoad()
        print("View did load")
        
        let name = UserDefaults.standard.value(forKey: "facebookName")
        let imageString = UserDefaults.standard.value(forKey: "facebookImage")
        let userGameHistory = UserDefaults.standard.value(forKey: "userGameHistory") as? [String:Any]
        let points = userGameHistory?["Points"] as? Int
        
        achievementsTableView.layer.cornerRadius = 10
        achievementsTableView.backgroundColor = UIColor.black
        achievementsTableView.backgroundColor = UIColor.clear.withAlphaComponent(0.0)
        
        userImage.sd_setImage(with: URL(string: imageString as! String), placeholderImage: UIImage(named: "placeholder"))
        userImage.layer.cornerRadius = 25
        userImage.layer.borderWidth = 1
        userImage.clipsToBounds = true
        userImage.contentMode = .scaleAspectFit
        userName.text = name as? String
        pointsLabel.text = "\(points!)"
        achievementsTableView.delegate = self
        achievementsTableView.dataSource = self
        achievementsTableView.separatorStyle = .none
        achievementsTableView.allowsSelection = false
        getUserAchievements()
        
        banner4.adUnitID = testAd
        banner4.rootViewController = self
        banner4.load(request)
        
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func close(_ sender: UIButton) {
         self.dismiss(animated: true, completion: nil)
    }
    
    func getUserAchievements() {
        for (key, value) in achievements! {
            if key == "getPair" {
                achieveKeys.remove(at: 0)
                achieveValues.remove(at: 0)
                achieveKeys.insert("Get a Pair", at: 0)
                achieveValues.insert("\(value)", at: 0)
                bonusPoints.remove(at: 0)
                bonusPoints.insert(tempAchievements.getPair.1, at: 0)
            }
            if key == "gettwoPair" {
                achieveKeys.remove(at: 1)
                achieveValues.remove(at: 1)
                achieveKeys.insert("Get Two Pair", at: 1)
                achieveValues.insert("\(value)", at: 1)
                bonusPoints.remove(at: 1)
                bonusPoints.insert(tempAchievements.getTwoPair.1, at: 1)
            }
            if key == "getthreeOfKind" {
                achieveKeys.remove(at: 2)
                achieveValues.remove(at: 2)
                achieveKeys.insert("Get Three of a Kind", at: 2)
                achieveValues.insert("\(value)", at: 2)
                bonusPoints.remove(at: 2)
                bonusPoints.insert(tempAchievements.getThreeOfKind.1, at: 2)
            }
            if key == "getStraight" {
                achieveKeys.remove(at: 3)
                achieveValues.remove(at: 3)
                achieveKeys.insert("Get a Straight", at: 3)
                achieveValues.insert("\(value)", at: 3)
                bonusPoints.remove(at: 3)
                bonusPoints.insert(tempAchievements.getStraight.1, at: 3)
            }
            if key == "getFlush" {
                achieveKeys.remove(at: 4)
                achieveValues.remove(at: 4)
                achieveKeys.insert("Get a Flush", at: 4)
                achieveValues.insert("\(value)", at: 4)
                bonusPoints.remove(at: 4)
                bonusPoints.insert(tempAchievements.getFlush.1, at: 4)
            }
            if key == "getFullHouse" {
                achieveKeys.remove(at: 5)
                achieveValues.remove(at: 5)
                achieveKeys.insert("Get a Full House", at: 5)
                achieveValues.insert("\(value)", at: 5)
                bonusPoints.remove(at: 5)
                bonusPoints.insert(tempAchievements.getFullHouse.1, at: 5)
            }
            if key == "getFourOfKind" {
                achieveKeys.remove(at: 6)
                achieveValues.remove(at: 6)
                achieveKeys.insert("Get Four of a Kind", at: 6)
                achieveValues.insert("\(value)", at: 6)
                bonusPoints.remove(at: 6)
                bonusPoints.insert(tempAchievements.getFourOfKind.1, at: 6)
            }
            if key == "getStraightFlush" {
                achieveKeys.remove(at: 7)
                achieveValues.remove(at: 7)
                achieveKeys.insert("Get a Straight Flush", at: 7)
                achieveValues.insert("\(value)", at: 7)
                bonusPoints.remove(at: 7)
                bonusPoints.insert(tempAchievements.getStraightFlush.1, at: 7)
            }
            if key == "getRoyalFlush" {
                achieveKeys.remove(at: 8)
                achieveValues.remove(at: 8)
                achieveKeys.insert("Get a Royal Flush", at: 8)
                achieveValues.insert("\(value)", at: 8)
                bonusPoints.remove(at: 8)
                bonusPoints.insert(tempAchievements.getRoyalFlush.1, at: 8)
            }
            if key == "getAllHandsInSingleGame" {
                achieveKeys.remove(at: 9)
                achieveValues.remove(at: 9)
                achieveKeys.insert("Get all hands in single game", at: 9)
                achieveValues.insert("\(value)", at: 9)
                bonusPoints.remove(at: 9)
                bonusPoints.insert(tempAchievements.getAllHandsInSingleGame.1, at: 9)
            }
            if key == "reach50Pairs" {
                achieveKeys.remove(at: 10)
                achieveValues.remove(at: 10)
                achieveKeys.insert("Reach 50 Pairs", at: 10)
                achieveValues.insert("\(value)", at: 10)
                bonusPoints.remove(at: 10)
                bonusPoints.insert(tempAchievements.reach50Pairs.1, at: 10)
            }
            if key == "reach50TwoPairs" {
                achieveKeys.remove(at: 11)
                achieveValues.remove(at: 11)
                achieveKeys.insert("Reach 50 Two Pairs", at: 11)
                achieveValues.insert("\(value)", at: 11)
                bonusPoints.remove(at: 11)
                bonusPoints.insert(tempAchievements.reach50TwoPairs.1, at: 11)
            }
            if key == "reach50ThreeOfKinds" {
                achieveKeys.remove(at: 12)
                achieveValues.remove(at: 12)
                achieveKeys.insert("Reach 50 Three of a Kind", at: 12)
                achieveValues.insert("\(value)", at: 12)
                bonusPoints.remove(at: 12)
                bonusPoints.insert(tempAchievements.reach50ThreeOfKinds.1, at: 12)
            }
            if key == "reach50Straights" {
                achieveKeys.remove(at: 13)
                achieveValues.remove(at: 13)
                achieveKeys.insert("Reach 50 Straights", at: 13)
                achieveValues.insert("\(value)", at: 13)
                bonusPoints.remove(at: 13)
                bonusPoints.insert(tempAchievements.reach50Straights.1, at: 13)
            }
            if key == "reach50Flushes" {
                achieveKeys.remove(at: 14)
                achieveValues.remove(at: 14)
                achieveKeys.insert("Reach 50 Flushes", at: 14)
                achieveValues.insert("\(value)", at: 14)
                bonusPoints.remove(at: 14)
                bonusPoints.insert(tempAchievements.reach50Flushes.1, at: 14)
            }
            if key == "reach50FullHouses" {
                achieveKeys.remove(at: 15)
                achieveValues.remove(at: 15)
                achieveKeys.insert("Reach 50 Full Houses", at: 15)
                achieveValues.insert("\(value)", at: 15)
                bonusPoints.remove(at: 15)
                bonusPoints.insert(tempAchievements.reach50Flushes.1, at: 15)
            }
            if key == "reach50FourOfKinds" {
                achieveKeys.remove(at: 16)
                achieveValues.remove(at: 16)
                achieveKeys.insert("Reach 50 Four of a Kind", at: 16)
                achieveValues.insert("\(value)", at: 16)
                bonusPoints.remove(at: 16)
                bonusPoints.insert(tempAchievements.reach50Flushes.1, at: 16)
            }
            if key == "reach50StraightFlushes" {
                achieveKeys.remove(at: 17)
                achieveValues.remove(at: 17)
                achieveKeys.insert("Reach 50 Straight Flushes", at: 17)
                achieveValues.insert("\(value)", at: 17)
                bonusPoints.remove(at: 17)
                bonusPoints.insert(tempAchievements.reach50Flushes.1, at: 17)
            }
            if key == "reach50RoyalFlushes" {
                achieveKeys.remove(at: 18)
                achieveValues.remove(at: 18)
                achieveKeys.insert("Reach 50 Royal Flushes", at: 18)
                achieveValues.insert("\(value)", at: 18)
                bonusPoints.remove(at: 18)
                bonusPoints.insert(tempAchievements.reach50Flushes.1, at: 18)
            }
        }
        self.achievementsTableView.reloadData()
    }
}

extension AchievementsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 110
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return achieveKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "achievement") as! AchievementsTableViewCell
            cell.achievementLabel.text = achieveKeys[indexPath.row]
            cell.pointsWorthLabel.text = "\(bonusPoints[indexPath.row])"
        
            print("Bonus Points +++ \(bonusPoints[indexPath.row])")
            if bonusPoints[indexPath.row] == 50 {
                cell.background.image = UIImage(named: "Button1")
            }
            if bonusPoints[indexPath.row] == 100 {
                cell.background.image = UIImage(named: "Button2")
            }
            if bonusPoints[indexPath.row] == 150 {
                cell.background.image = UIImage(named: "Button3")
            }
            if bonusPoints[indexPath.row] == 200 {
                cell.background.image = UIImage(named: "Button1")
            }
            if bonusPoints[indexPath.row] == 1000 {
                cell.background.image = UIImage(named: "Button2")
            }
            if bonusPoints[indexPath.row] == 500 {
                cell.background.image = UIImage(named: "Button3")
            }
        
            if achieveValues[indexPath.row] == "true" {
                cell.checkmarkImage.image = UIImage(named: "checkmark")
            } else {
                cell.checkmarkImage.image = UIImage(named: "xmark")
            }
            return cell
    }
    
}
