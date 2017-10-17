//
//  FeedbackViewController.swift
//  fortyFives
//
//  Created by Rich Ruais on 10/13/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.
//

import UIKit
import MessageUI
import Firebase

class FeedbackViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var banner5: GADBannerView!
    let request = GADRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = UserDefaults.standard.value(forKey: "facebookName")
        let imageString = UserDefaults.standard.value(forKey: "facebookImage")
        let userGameHistory = UserDefaults.standard.value(forKey: "userGameHistory") as? [String:Any]
        let points = userGameHistory?["Points"] as? Int
        userImage.sd_setImage(with: URL(string: imageString as! String), placeholderImage: UIImage(named: "placeholder"))
        userImage.layer.cornerRadius = 25
        userImage.layer.borderWidth = 1
        userImage.clipsToBounds = true
        userImage.contentMode = .scaleAspectFit
        userName.text = name as? String
        pointsLabel.text = "\(points!)"
     
        textView.layer.cornerRadius = 10
        textView.delegate = self
        
        hideKeyboardWhenTappedAround()
        
        banner5.adUnitID = testAd
        banner5.rootViewController = self
        banner5.load(request)
    }
    

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func sendAction(_ sender: UIButton) {
        self.sendEmail()
    }
    

    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension FeedbackViewController: MFMailComposeViewControllerDelegate, UITextViewDelegate {
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["richruais@gmail.com"])
            mail.setMessageBody(textView.text, isHTML: true)
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FeedbackViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        textView.resignFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
}
