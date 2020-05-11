//
//  MainCoordinator.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 02.05.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit
import Foundation

final class MainCoordinator: BaseCoordinator {
    
    //MARK: - Properties
    //
    private let router: RouterProtocol
    private let tabBarController = UITabBarController()
    // navControllers
    var catsFeedRootNavigationController: UINavigationController!
    var imageUploadRootNavigationController: UINavigationController!
    var profileRootNavigationController: UINavigationController!
    // coordinators
    var feedCoordinator: CatsFeedCoordinator!
    var uploadCoordinator: CatImageUploadCoordinator!
    var profileCoordinator: ProfileCoordinator!
    
    //MARK: - inits
    //
    init(router: RouterProtocol) {
        self.router = router
    }
    
    //MARK: - Coordinator
    //
    override func start() {
        setupMainCoordinator()
    }
    
    //MARK: - Show ViewControllers
    //
    private func setupMainCoordinator(){
        // 1. create root NavControllers
        catsFeedRootNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchNavigationController") as? UINavigationController
        imageUploadRootNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UploadNavigationController") as? UINavigationController
        profileRootNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileNavigationController") as? UINavigationController
        // 2. create child Coordinators
        feedCoordinator = CatsFeedCoordinator(router: Router(rootController: catsFeedRootNavigationController))
        uploadCoordinator = CatImageUploadCoordinator(router: Router(rootController: imageUploadRootNavigationController))
        profileCoordinator = ProfileCoordinator(router: Router(rootController: profileRootNavigationController))
        // 3. add dependencies
        self.addDependency(feedCoordinator)
        self.addDependency(uploadCoordinator)
        self.addDependency(profileCoordinator)
        // 4. setup tabBarController
        tabBarController.delegate = self
        tabBarController.viewControllers = [catsFeedRootNavigationController,
                                            imageUploadRootNavigationController,
                                            profileRootNavigationController]
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.tintColor = UIColor.systemGreen
        tabBarController.tabBar.unselectedItemTintColor = UIColor.darkGray
        tabBarController.selectedIndex = 0
        // 5. start children coordinators
        for coordinator in childCoordinators {
            coordinator.start()
        }
        // 6. set root
        self.router.setRootModule(tabBarController, hideBar: true)
        
    }
    
}

extension MainCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        switch viewController {
        case catsFeedRootNavigationController:
            feedCoordinator.scrollToTop()
        case profileRootNavigationController:
            // implement scrollToTop for currently presented Uploads/Favs/Votes CVC
            break
        default:
            break
        }
    }
}
