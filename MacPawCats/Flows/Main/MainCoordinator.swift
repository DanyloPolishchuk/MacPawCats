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
        guard let catsFeedRootNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchNavigationController") as? UINavigationController,
        let imageUploadRootNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UploadNavigationController") as? UINavigationController,
            let profileRootNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileNavigationController") as? UINavigationController else {return}
        // 2. create child Coordinators
        let feedCoordinator = CatsFeedCoordinator(router: Router(rootController: catsFeedRootNavigationController))
        let uploadCoordinator = CatImageUploadCoordinator(router: Router(rootController: imageUploadRootNavigationController))
        let profileCoordinator = ProfileCoordinator(router: Router(rootController: profileRootNavigationController))
        // 3. add dependencies
        self.addDependency(feedCoordinator)
        self.addDependency(uploadCoordinator)
        self.addDependency(profileCoordinator)
        // 4. setup tabBarController
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
