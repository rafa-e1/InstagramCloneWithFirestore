//
//  MainTabBarController.swift
//  Instagram
//
//  Created by RAFA on 5/15/24.
//

import UIKit

import FirebaseAuth
import YPImagePicker

class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    private var user: User? {
        didSet {
            guard let user = user else { return }
            configureViewControllers(withUser: user)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        fetchUser()
    }
    
    // MARK: - API
    
    func fetchUser() {
        UserService.fetchUser { user in
            self.user = user
        }
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self
                let navigationController = UINavigationController(rootViewController: controller)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true)
            }
        }
    }
    
    // MARK: - Helpers
    
    func configureViewControllers(withUser user: User) {
        delegate = self
        
        let feedLayout = UICollectionViewFlowLayout()
        let feed = templateNavigationController(
            unselectedImage: #imageLiteral(resourceName: "home_unselected"),
            selectedImage: #imageLiteral(resourceName: "home_selected"),
            rootViewController: FeedController(collectionViewLayout: feedLayout)
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
        
        let profileController = ProfileController(user: user)
        let profile = templateNavigationController(
            unselectedImage: #imageLiteral(resourceName: "profile_unselected"),
            selectedImage: #imageLiteral(resourceName: "profile_selected"),
            rootViewController: profileController
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
    
    func didFinishPickingMedia(_ picker: YPImagePicker) {
        picker.didFinishPicking { items, _ in
            picker.dismiss(animated: false) {
                guard let selectedImage = items.singlePhoto?.image else { return }
                
                let controller = UploadPostController()
                controller.selectedImage = selectedImage
                controller.delegate = self
                controller.currentUser = self.user
                
                let navigationController = UINavigationController(rootViewController: controller)
                navigationController.modalPresentationStyle = .fullScreen
                
                self.present(navigationController, animated: false)
            }
        }
    }
}

// MARK: - AuthenticationDelegate

extension MainTabBarController: AuthenticationDelegate {
    func authenticationDidComplete() {
        fetchUser()
        dismiss(animated: true)
    }
}

// MARK: - UITabBarControllerDelegate

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 {
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.library.maxNumberOfItems = 1
            
            let picker = YPImagePicker(configuration: config)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true)
            
            didFinishPickingMedia(picker)
        }
        
        return true
    }
}

// MARK: - UploadPostControllerDelegate

extension MainTabBarController: UploadPostControllerDelegate {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController) {
        selectedIndex = 0
        controller.dismiss(animated: true)
        
        guard let feedNav = viewControllers?.first as? UINavigationController else { return }
        guard let feed = feedNav.viewControllers.first as? FeedController else { return }
        feed.handleRefresh()
    }
}
