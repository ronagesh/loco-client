//
//  TutorialPageViewController.swift
//  loco
//
//  Created by Rohan Nagesh on 7/7/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    // MARK: Model
    private var tutorialImages = ["tutorial_screen_1", "tutorial_screen_2", "tutorial_screen_3"]
    private var tutorialBlurbs = [NSLocalizedString("Tell us what foods you like and your budget.", comment: "Blurb on first tutorial screen"), NSLocalizedString("We will show you 5 personalized experiences ready to go.", comment: "Blurb on second tutorial screen"), NSLocalizedString("Pick one. We'll make reservations and send a car to pick you up!", comment: "Blurb on third tutorial screen")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stylePageControl()
        dataSource = self
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let contentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("tutorialContentViewController") as! TutorialPageContentController
        
        contentViewController.imageName = tutorialImages[0]
        contentViewController.blurbString = tutorialBlurbs[0]
        setViewControllers([contentViewController], direction: .Forward, animated: true, completion: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UIPageViewControllerDataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if let tutorialPageContentController = viewController as? TutorialPageContentController {
            //Lookup viewController's imageName to get its index
            guard let viewControllerIndex = tutorialImages.indexOf(tutorialPageContentController.imageName) else {
                return nil
            }
                
            let prevIndex = viewControllerIndex - 1
                
            guard prevIndex >= 0 else {
                return nil
            }
                
            let prevViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("tutorialContentViewController") as! TutorialPageContentController
            
            prevViewController.imageName = tutorialImages[prevIndex]
            prevViewController.blurbString = tutorialBlurbs[prevIndex]
                
            return prevViewController
        }
        
        return nil
 
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if let tutorialPageContentController = viewController as? TutorialPageContentController {
            
            guard let viewControllerIndex = tutorialImages.indexOf(tutorialPageContentController.imageName) else {
                return nil
            }

            
            let nextIndex = viewControllerIndex + 1
                
            guard nextIndex < tutorialImages.count else {
                return nil
            }
                
                
            let nextViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("tutorialContentViewController") as! TutorialPageContentController
            
            nextViewController.imageName = tutorialImages[nextIndex]
            nextViewController.blurbString = tutorialBlurbs[nextIndex]
            
            return nextViewController

        }
        
        return nil
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return tutorialImages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    private func stylePageControl() {
        let pageControl = UIPageControl.appearanceWhenContainedInInstancesOfClasses([self.dynamicType])
        
        pageControl.currentPageIndicatorTintColor = UIColor.blackColor()
        pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageControl.backgroundColor = UIColor.whiteColor()
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
