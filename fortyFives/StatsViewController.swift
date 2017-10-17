//
//  StatsViewController.swift
//  fortyFives
//
//  Created by Rich Ruais on 10/10/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.
//

import UIKit

import UIKit
import Firebase
import FirebaseDatabase

class StatsViewController: UIViewController {
    
    @IBOutlet weak var statsTableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var banner3: GADBannerView!
    let request = GADRequest()
    
    var statsKeys = ["","","","","","","","","","",""]
    var statsValues = ["","","","","","","","","","",""]
    
    let userGameHistory = UserDefaults.standard.value(forKey: "userGameHistory") as? [String:Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View did load")
        
        let name = UserDefaults.standard.value(forKey: "facebookName")
        let imageString = UserDefaults.standard.value(forKey: "facebookImage")
        let userGameHistory = UserDefaults.standard.value(forKey: "userGameHistory") as? [String:Any]
        let points = userGameHistory?["Points"] as? Int
        
        
        statsTableView.layer.cornerRadius = 10
        statsTableView.backgroundColor = UIColor.black
        statsTableView.backgroundColor = UIColor.clear.withAlphaComponent(0.0)
        
        userImage.sd_setImage(with: URL(string: imageString as! String), placeholderImage: UIImage(named: "placeholder"))
        userImage.layer.cornerRadius = 25
        userImage.layer.borderWidth = 1
        userImage.clipsToBounds = true
        userImage.contentMode = .scaleAspectFit
        userName.text = name as? String
        pointsLabel.text = "\(points!)"
        
        getUserAchievements()
        statsTableView.delegate = self
        statsTableView.dataSource = self
        statsTableView.separatorStyle = .none
        statsTableView.allowsSelection = false
        
        banner3.adUnitID = testAd
        banner3.rootViewController = self
        banner3.load(request)
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getUserAchievements() {
        for (key, value) in userGameHistory! {
            if key == "Best Score" {
                statsKeys.remove(at: 0)
                statsValues.remove(at: 0)
                self.statsKeys.insert(key, at: 0)
                self.statsValues.insert("\(value)", at: 0)
            }
            if key == "Lifetime Points" {
                statsKeys.remove(at: 1)
                statsValues.remove(at: 1)
                self.statsKeys.insert(key, at: 1)
                self.statsValues.insert("\(value)", at: 1)
            }
            if key == "Pair" {
                statsKeys.remove(at: 2)
                statsValues.remove(at: 2)
                self.statsKeys.insert(key, at: 2)
                self.statsValues.insert("\(value)", at: 2)
            }
            if key == "Two Pair" {
                statsKeys.remove(at: 3)
                statsValues.remove(at: 3)
                self.statsKeys.insert(key, at: 3)
                self.statsValues.insert("\(value)", at: 3)
            }
            if key == "Three of a Kind" {
                statsKeys.remove(at: 4)
                statsValues.remove(at: 4)
                self.statsKeys.insert(key, at: 4)
                self.statsValues.insert("\(value)", at: 4)
            }
            if key == "Straight" {
                statsKeys.remove(at: 5)
                statsValues.remove(at: 5)
                self.statsKeys.insert(key, at: 5)
                self.statsValues.insert("\(value)", at: 5)
            }
            if key == "Flush" {
                statsKeys.remove(at: 6)
                statsValues.remove(at: 6)
                self.statsKeys.insert(key, at: 6)
                self.statsValues.insert("\(value)", at: 6)
            }
            if key == "Full House" {
                statsKeys.remove(at: 7)
                statsValues.remove(at: 7)
                self.statsKeys.insert(key, at: 7)
                self.statsValues.insert("\(value)", at: 7)
            }
            if key == "Four of a Kind" {
                statsKeys.remove(at: 8)
                statsValues.remove(at: 8)
                self.statsKeys.insert(key, at: 8)
                self.statsValues.insert("\(value)", at: 8)
            }
            if key == "Straight Flush" {
                statsKeys.remove(at: 9)
                statsValues.remove(at: 9)
                self.statsKeys.insert(key, at: 9)
                self.statsValues.insert("\(value)", at: 9)
            }
            if key == "Royal Flush" {
                statsKeys.remove(at: 10)
                statsValues.remove(at: 10)
                self.statsKeys.insert(key, at: 10)
                self.statsValues.insert("\(value)", at: 10)
            }
        }
        
        self.statsTableView.reloadData()
    }
}

extension StatsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return statsKeys.count
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "stats") as!StatsTableViewCell
            cell.handLabel.text = statsKeys[indexPath.row]
            cell.pointsLabel.text = statsValues[indexPath.row]
            return cell
    }
    
}
