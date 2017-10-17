//
//  ContainerViewController.swift
//  fortyFives
//
//  Created by Rich Ruais on 10/16/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private lazy var achievementsViewController: AchievementsViewController = {
        let storyboard = UIStoryboard(name: "TabBar", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "AchievementsViewController") as! AchievementsViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var statsViewController: StatsViewController = {
        let storyboard = UIStoryboard(name: "TabBar", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "StatsViewController") as! StatsViewController
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }

 
    @IBAction func statsAction(_ sender: UIButton) {
        remove(asChildViewController: achievementsViewController)
        add(asChildViewController: statsViewController)
    }

    @IBAction func achievementsAction(_ sender: UIButton) {
        remove(asChildViewController: statsViewController)
        add(asChildViewController: achievementsViewController)
    }
}
