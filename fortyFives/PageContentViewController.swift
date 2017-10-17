//
//  PageContentViewController.swift
//  fortyFives
//
//  Created by Rich Ruais on 10/16/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.
//

import UIKit
import Firebase

class PageContentViewController: UIViewController {

    @IBOutlet weak var mainImageView: UIImageView!

    
    var name = String()
    var imageString = String()
    var userGameHistory = [String:Any]()
    var points = Int()
    
    var image: UIImage?
    var pageIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainImageView.image = image
    
      
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    



    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
