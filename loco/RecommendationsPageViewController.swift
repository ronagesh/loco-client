//
//  RecommendationsPageViewController.swift
//  loco
//
//  Created by Rohan Nagesh on 7/16/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit

class RecommendationsPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    // MARK: Model
    private var restaurants = [Restaurant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stylePageControl()
        dataSource = self
        self.view.backgroundColor = UIColor.whiteColor()
        
        
        
        //TODO: Code to fetch restaurants from backend
        
        
        //Hardcoded Restaurants for now
        let rest1 = Restaurant(name: "Wayfare Tavern", imageURL: "wayfare_tavern", cuisineType: RestaurantCuisines.American, address: "San Francisco", budgetRating: RestaurantBudgetRatings.Luxe, blurb: "We picked this restaurant for its unique ambience and 4-star rating on Yelp.")
        
        let rest2 = Restaurant(name: "Zazie", imageURL: "zazie", cuisineType: RestaurantCuisines.French, address: "San Francisco", budgetRating: RestaurantBudgetRatings.Upscale, blurb: "We picked this restaurant for its unique French offering and 4-star rating on Yelp.")
        
        let rest3 = Restaurant(name: "Skool", imageURL: "skool", cuisineType: RestaurantCuisines.American, address: "San Francisco", budgetRating: RestaurantBudgetRatings.Upscale, blurb: "We picked this restaurant for its unique seafood offering and 4-star rating on Yelp.")
        
        restaurants.append(rest1)
        restaurants.append(rest2)
        restaurants.append(rest3)
        
        let contentViewController = UIStoryboard(name: "Core", bundle: nil).instantiateViewControllerWithIdentifier("restaurantContentViewController") as! RecommendationsContentViewController
        
        contentViewController.restaurant = restaurants[0]
        setViewControllers([contentViewController], direction: .Forward, animated: true, completion: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UIPageViewControllerDataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if let restaurantContentController = viewController as? RecommendationsContentViewController {
            
            //Lookup viewController's attached restaurant to get its index in the restaurants array in model
            guard let viewControllerIndex = restaurants.indexOf({
                $0.name == restaurantContentController.restaurant.name
            }) else {
                return nil
            }
            
            let prevIndex = viewControllerIndex - 1
            
            guard prevIndex >= 0 else {
                return nil
            }
            
            let prevViewController = UIStoryboard(name: "Core", bundle: nil).instantiateViewControllerWithIdentifier("restaurantContentViewController") as! RecommendationsContentViewController
            
            prevViewController.restaurant = restaurants[prevIndex]
            
            return prevViewController
        }
        
        return nil
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if let restaurantContentController = viewController as? RecommendationsContentViewController {
            
            //Lookup viewController's attached restaurant to get its index in the restaurants array in model
            guard let viewControllerIndex = restaurants.indexOf({
                $0.name == restaurantContentController.restaurant.name
            }) else {
                return nil
            }

            let nextIndex = viewControllerIndex + 1
            
            guard nextIndex < restaurants.count else {
                return nil
            }
            
            let nextViewController = UIStoryboard(name: "Core", bundle: nil).instantiateViewControllerWithIdentifier("restaurantContentViewController") as! RecommendationsContentViewController
            
            nextViewController.restaurant = restaurants[nextIndex]
            
            return nextViewController
            
        }
        
        return nil
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return restaurants.count
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
