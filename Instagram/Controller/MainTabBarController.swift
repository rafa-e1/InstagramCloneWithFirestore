//
//  MainTabBarController.swift
//  Instagram
//
//  Created by RAFA on 5/15/24.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewControllers()
    }
    
    // MARK: - Helpers
    
    func configureViewControllers() {
        let feed = templateNavigationController(
            unselectedImage: #imageLiteral(resourceName: "home_unselected"),
            selectedImage: #imageLiteral(resourceName: "home_selected"),
            rootViewController: FeedController()
        )
        
        let search = templateNavigationController(
            unselectedImage: #imageLiteral(resourceName: "search_unselected"),
            selectedImage: #imageLiteral(resourceName: "search_selected"),
            rootViewController: SearchController()
        )
        
        let imageSelector = templateNavigationController(
            unselectedImage: #imageLiteral(resourceName: "plus_unselected"),
            selectedImage: #imageLiteral(resourceName: "plus_unselected"),
            rootViewController: ImageSelectorController()
        )
        
        let notification = templateNavigationController(
            unselectedImage: #imageLiteral(resourceName: "like_unselected"),
            selectedImage: #imageLiteral(resourceName: "like_selected"),
            rootViewController: NotificationController()
        )
        
        let profile = templateNavigationController(
            unselectedImage: #imageLiteral(resourceName: "profile_unselected"),
            selectedImage: #imageLiteral(resourceName: "profile_selected"),
            rootViewController: ProfileController()
        )
        
        viewControllers = [feed, search, imageSelector, notification, profile]
    }
    
    func templateNavigationController(
        unselectedImage: UIImage,
        selectedImage: UIImage,
        rootViewController: UIViewController
    ) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        tabBar.tintColor = .black
        navigationController.tabBarItem.image = unselectedImage
        navigationController.tabBarItem.selectedImage = selectedImage
        navigationController.navigationBar.tintColor = .black
        return navigationController
    }
    
}
