//
//  InstructionsPageViewController.swift
//  fortyFives
//
//  Created by Rich Ruais on 10/16/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.
//

import UIKit

class InstructionsPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var images =  [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        images = [#imageLiteral(resourceName: "Instructions1"), #imageLiteral(resourceName: "Instructions2"), #imageLiteral(resourceName: "Instructions3"), #imageLiteral(resourceName: "Instructions4"), #imageLiteral(resourceName: "Instructions5"), #imageLiteral(resourceName: "Instructions6")]
        self.dataSource = self
        self.setViewControllers([getViewControllerAtIndex(index: 0)] as [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        let pageContent: PageContentViewController = viewController as! PageContentViewController
        var index = pageContent.pageIndex
        if ((index == 0) || (index == NSNotFound))
        {
            return nil
        }
        index -= 1
        return getViewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let pageContent: PageContentViewController = viewController as! PageContentViewController
        var index = pageContent.pageIndex
        if (index == NSNotFound)
        {
            return nil;
        }
        index += 1;
        if (index == images.count)
        {
            return nil;
        }
        return getViewControllerAtIndex(index: index)
    }
    
    func getViewControllerAtIndex(index: NSInteger) -> PageContentViewController
    {
        // Create a new view controller and pass suitable data.
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController
        pageContentViewController.image = images[index]
        pageContentViewController.pageIndex = index
        return pageContentViewController
    }

  
}
